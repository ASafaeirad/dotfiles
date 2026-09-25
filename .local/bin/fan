#!/usr/bin/env bash

# Single source of truth for fan policy on this ASUS laptop. The shell's Fans settings page
# reads and writes through here; it decides *when* to act, never *what* an action means.
#
# Curve writes go through asusctl, which talks to asusd (already root) -- this script never
# writes sysfs and never needs sudo. Sensor reads come straight from sysfs, except the dGPU
# temperature: see gpu_temp().
#
# Curves are carried as raw PWM (0-255), never as the percentages asusctl prints. asusctl
# truncates when it renders a percentage, so a curve that makes a percent round trip loses
# about 1% per cycle and ratchets itself down. Percent is a presentation format only.

set -uo pipefail

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/fan"
SNAPSHOT="$STATE_DIR/fullspeed.json"

FULL_CURVE='30c:255,40c:255,50c:255,60c:255,70c:255,80c:255,90c:255,100c:255'
FANS=(cpu gpu mid)

usage() {
  echo "Usage: fan <command>"
  echo "status                show a human-readable summary (default)"
  echo "sensors               print live temperatures and fan speeds as JSON"
  echo "hwmon                 print the discovered sysfs sensor paths as JSON"
  echo "curve get             print the active profile's curves as JSON"
  echo "curve set <data>      apply <data> to the cpu, gpu and mid fans and enable curves"
  echo "                        8 points, PWM '60c:128,...' or percent '60c:50%,...'"
  echo "curve reset           restore the active profile's factory curve and disable curves"
  echo "full <on|off>         run every fan flat out, restoring the previous curve on 'off'"
  echo "full status           print on or off"
  echo "slow                  Quiet profile; releases full speed if it is engaged"
  echo "default               Balanced profile; releases full speed if it is engaged"
  echo "max                   Performance profile with every fan flat out"
  echo "-h                    show this help"
}

die() {
  echo "fan: $1" >&2
  exit "${2:-1}"
}

require_asusctl() {
  command -v asusctl >/dev/null 2>&1 || die "asusctl is not installed"
}

# --- sysfs discovery --------------------------------------------------------
# hwmon numbering is assigned in probe order and is not stable across boots, so every path
# below is resolved by device name rather than hardcoded. A consumer that caches these paths
# must re-resolve them after a reboot.

hwmon_by_name() {
  local want="$1" dir
  for dir in /sys/class/hwmon/hwmon*; do
    [[ -r "$dir/name" ]] || continue
    [[ "$(<"$dir/name")" == "$want" ]] && { printf '%s' "$dir"; return 0; }
  done
  return 1
}

# The asus hwmon exposes cpu_fan / gpu_fan / mid_fan, but which fanN index each lands on is
# not guaranteed, so match on the label rather than assuming fan1 is the CPU.
fan_input_for() {
  local asus="$1" want="$2" label
  [[ -n "$asus" ]] || return 1
  for label in "$asus"/fan*_label; do
    [[ -r "$label" ]] || continue
    [[ "$(<"$label")" == "$want" ]] || continue
    printf '%s' "${label%_label}_input"
    return 0
  done
  return 1
}

# coretemp's package sensor is the one that drives the CPU fan curve; the per-core sensors
# are noisier and would make the readout jitter.
cpu_temp_input() {
  local core="$1" label
  [[ -n "$core" ]] || return 1
  for label in "$core"/temp*_label; do
    [[ -r "$label" ]] || continue
    [[ "$(<"$label")" == "Package id 0" ]] || continue
    printf '%s' "${label%_label}_input"
    return 0
  done
  # Other CPUs may not label a package sensor; temp1 is the conventional fallback.
  [[ -r "$core/temp1_input" ]] && printf '%s' "$core/temp1_input"
}

read_milli() {
  # sysfs reports temperatures in millidegrees. Empty on an unreadable sensor, never 0:
  # a missing reading and a 0 degree reading must not look the same downstream.
  [[ -n "${1:-}" && -r "${1:-}" ]] || return
  local raw
  raw=$(<"$1") || return
  [[ "$raw" =~ ^-?[0-9]+$ ]] || return
  awk -v v="$raw" 'BEGIN { printf "%.0f", v / 1000 }'
}

read_int() {
  [[ -n "${1:-}" && -r "${1:-}" ]] || return
  local raw
  raw=$(<"$1") || return
  [[ "$raw" =~ ^-?[0-9]+$ ]] && printf '%s' "$raw"
}

dgpu_status() {
  local dev
  for dev in /sys/bus/pci/devices/*/; do
    [[ -r "$dev/vendor" && -r "$dev/class" ]] || continue
    [[ "$(<"$dev/vendor")" == 0x10de && "$(<"$dev/class")" == 0x030000 ]] || continue
    [[ -r "$dev/power/runtime_status" ]] && printf '%s' "$(<"$dev/power/runtime_status")"
    return
  done
}

gpu_temp() {
  # HARD CONSTRAINT, shared with powerlog: never query NVML on a suspended dGPU. Doing so
  # wakes it, which costs several watts and would make this readout the reason the battery
  # drains. No reading is the correct answer while it sleeps.
  [[ "$(dgpu_status)" == "active" ]] || return
  command -v nvidia-smi >/dev/null 2>&1 || return
  local out
  out=$(timeout 2 nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null | head -n 1)
  [[ "$out" =~ ^[0-9]+$ ]] && printf '%s' "$out"
}

platform_profile() {
  [[ -r /sys/firmware/acpi/platform_profile ]] && printf '%s' "$(</sys/firmware/acpi/platform_profile)"
}

# asusctl capitalises profile names; the kernel's platform_profile does not.
asus_profile() {
  case "$(platform_profile)" in
    quiet) printf 'Quiet' ;;
    balanced) printf 'Balanced' ;;
    performance) printf 'Performance' ;;
    *) return 1 ;;
  esac
}

json_num() {
  # An unreadable sensor becomes null, so consumers can tell "no data" from a real value.
  [[ -n "${1:-}" ]] && printf '%s' "$1" || printf 'null'
}

json_str() {
  [[ -n "${1:-}" ]] || { printf 'null'; return; }
  printf '"%s"' "${1//\"/\\\"}"
}

# --- curve reading ----------------------------------------------------------
# Parses `asusctl fan-curve --mod-profile <p>`, whose output is a Rust debug dump:
#   ( fan: CPU, pwm: (2, 17, ...), temp: (62, 67, ...), enabled: false, )
# Emits one line per fan: <id>|<enabled>|<temp>c:<pwm>,...

curve_lines() {
  local profile="$1"
  asusctl fan-curve --mod-profile "$profile" 2>/dev/null | awk '
    function tuple(line,   s) {
      s = line
      sub(/^[^(]*\(/, "", s)
      sub(/\).*$/, "", s)
      gsub(/[ \t]/, "", s)
      return s
    }
    /fan:/ {
      fan = $0; sub(/^[^:]*:[ \t]*/, "", fan); gsub(/[ \t,]/, "", fan); fan = tolower(fan)
    }
    /pwm:/  { split(tuple($0), P, ",") }
    /temp:/ { split(tuple($0), T, ",") }
    /enabled:/ {
      en = $0; sub(/^[^:]*:[ \t]*/, "", en); gsub(/[ \t,]/, "", en)
      data = ""
      for (i = 1; i in T; i++) data = data (i > 1 ? "," : "") T[i] "c:" P[i]
      if (fan != "" && data != "") print fan "|" en "|" data
      fan = ""; delete P; delete T
    }
  '
}

# "62c:2,67c:17,..." -> [{"temp":62,"pwm":2},...]
points_json() {
  awk -v data="$1" 'BEGIN {
    n = split(data, pts, ",")
    printf "["
    for (i = 1; i <= n; i++) {
      split(pts[i], kv, ":")
      t = kv[1]; sub(/c$/, "", t)
      printf "%s{\"temp\":%d,\"pwm\":%d}", (i > 1 ? "," : ""), t, kv[2]
    }
    printf "]"
  }'
}

# --- commands ---------------------------------------------------------------

cmd_hwmon() {
  local asus core cpu_input id label input first=1
  asus=$(hwmon_by_name asus)
  core=$(hwmon_by_name coretemp)
  cpu_input=$(cpu_temp_input "$core")

  printf '{"asus":%s,"coretemp":%s,"cpuTempInput":%s,"fans":[' \
    "$(json_str "$asus")" "$(json_str "$core")" "$(json_str "$cpu_input")"

  for id in "${FANS[@]}"; do
    input=$(fan_input_for "$asus" "${id}_fan") || continue
    case $id in
      cpu) label="CPU" ;;
      gpu) label="GPU" ;;
      mid) label="Mid" ;;
    esac
    (( first )) || printf ','
    first=0
    printf '{"id":"%s","label":"%s","path":%s}' "$id" "$label" "$(json_str "$input")"
  done

  printf ']}\n'
}

cmd_sensors() {
  local asus core id input rpm first=1
  asus=$(hwmon_by_name asus)
  core=$(hwmon_by_name coretemp)

  printf '{"profile":%s,"cpuTemp":%s,"gpuTemp":%s,"dgpu":%s,"fans":[' \
    "$(json_str "$(platform_profile)")" \
    "$(json_num "$(read_milli "$(cpu_temp_input "$core")")")" \
    "$(json_num "$(gpu_temp)")" \
    "$(json_str "$(dgpu_status)")"

  for id in "${FANS[@]}"; do
    input=$(fan_input_for "$asus" "${id}_fan") || continue
    rpm=$(read_int "$input")
    (( first )) || printf ','
    first=0
    printf '{"id":"%s","rpm":%s}' "$id" "$(json_num "$rpm")"
  done

  printf ']}\n'
}

cmd_curve_get() {
  require_asusctl
  local profile id enabled data first=1
  profile=$(asus_profile) || die "could not read the active platform profile"

  printf '{"profile":"%s","fullSpeed":%s,"fans":[' \
    "$profile" "$([[ -s "$SNAPSHOT" ]] && echo true || echo false)"

  while IFS='|' read -r id enabled data; do
    [[ -n "$id" && -n "$data" ]] || continue
    (( first )) || printf ','
    first=0
    printf '{"id":"%s","enabled":%s,"data":"%s","points":%s}' \
      "$id" "$([[ "$enabled" == "true" ]] && echo true || echo false)" \
      "$data" "$(points_json "$data")"
  done < <(curve_lines "$profile")

  printf ']}\n'
}

# Accepts PWM ("60c:128") or percent ("60c:50%"), and range-checks the values: asusctl will
# happily take a nonsense PWM of 900 and clamp or wrap it somewhere in the firmware.
validate_curve() {
  local data="$1"
  if [[ "$data" =~ ^([0-9]{1,3}c:[0-9]{1,3}%,){7}[0-9]{1,3}c:[0-9]{1,3}%$ ]]; then
    awk -v d="$data" 'BEGIN {
      n = split(d, p, ",")
      for (i = 1; i <= n; i++) {
        split(p[i], kv, ":")
        v = kv[2]; sub(/%$/, "", v)
        if (v + 0 > 100) exit 1
      }
    }' || die "fan percentages must be 0-100" 2
  elif [[ "$data" =~ ^([0-9]{1,3}c:[0-9]{1,3},){7}[0-9]{1,3}c:[0-9]{1,3}$ ]]; then
    awk -v d="$data" 'BEGIN {
      n = split(d, p, ",")
      for (i = 1; i <= n; i++) {
        split(p[i], kv, ":")
        if (kv[2] + 0 > 255) exit 1
      }
    }' || die "fan PWM values must be 0-255" 2
  else
    die "curve must be 8 points like '60c:128,...' or '60c:50%,...' (got '$data')" 2
  fi

  awk -v d="$data" 'BEGIN {
    n = split(d, p, ",")
    for (i = 1; i <= n; i++) {
      split(p[i], kv, ":")
      t = kv[1]; sub(/c$/, "", t)
      if (t + 0 < prev) exit 1
      prev = t + 0
    }
  }' || die "curve temperatures must not decrease" 2

  # A curve whose fan speeds dip is accepted by asusctl with exit 0 and then dropped on the
  # floor by the firmware -- the write silently does nothing at all. Refuse it here so the
  # caller hears about it instead of believing a no-op succeeded.
  awk -v d="$data" 'BEGIN {
    n = split(d, p, ",")
    for (i = 1; i <= n; i++) {
      split(p[i], kv, ":")
      v = kv[2]; sub(/%$/, "", v)
      if (v + 0 < prev) exit 1
      prev = v + 0
    }
  }' || die "fan speeds must not decrease as temperature rises; the firmware discards such a curve" 2
}

# Writes one curve to every fan of $1 and turns custom curves on. asusctl exits non-zero on a
# rejected curve; surface that rather than reporting a write that never landed.
write_curve() {
  local profile="$1" data="$2" id
  for id in "${FANS[@]}"; do
    asusctl fan-curve --mod-profile "$profile" --fan "$id" --data "$data" >/dev/null \
      || die "asusctl refused the curve for the $id fan"
  done
  asusctl fan-curve --mod-profile "$profile" --enable-fan-curves true >/dev/null \
    || die "asusctl could not enable fan curves for $profile"
}

cmd_curve_set() {
  require_asusctl
  local data="${1:-}" profile
  [[ -n "$data" ]] || die "curve set needs curve data (try -h)" 2
  validate_curve "$data"
  profile=$(asus_profile) || die "could not read the active platform profile"

  # Refuse rather than silently discard: with full speed engaged the snapshot holds the curve
  # that 'full off' will restore, so writing now would be undone the moment it is released.
  [[ -s "$SNAPSHOT" ]] && die "full speed is engaged; run 'fan full off' before editing the curve"

  write_curve "$profile" "$data"
  echo "Curve applied to $profile (cpu, gpu, mid): $data"
}

cmd_curve_reset() {
  require_asusctl
  local profile
  profile=$(asus_profile) || die "could not read the active platform profile"
  [[ -s "$SNAPSHOT" ]] && die "full speed is engaged; run 'fan full off' first"

  # --default acts on the active profile, which is the one asus_profile just named.
  asusctl fan-curve --default >/dev/null || die "asusctl could not restore the default curve"
  asusctl fan-curve --mod-profile "$profile" --enable-fan-curves false >/dev/null \
    || die "asusctl could not hand control back to the firmware"
  echo "Curve reset to factory default for $profile; firmware control restored"
}

# --- full speed -------------------------------------------------------------
# Turning full speed on overwrites all three curves, so the previous ones are snapshotted to
# disk first. The snapshot is the single record that an override is active: it outlives the
# shell, so a crash or a logout still leaves 'fan full off' able to put the fans back.

cmd_full_on() {
  require_asusctl
  local profile id enabled data first=1
  profile=$(asus_profile) || die "could not read the active platform profile"

  if [[ -s "$SNAPSHOT" ]]; then
    # Already on for this same profile: re-snapshotting would capture the flat-out curve and
    # make the real one unrecoverable. This is why 'on' is not simply idempotent-by-rewrite.
    if [[ "$(snapshot_profile)" == "$profile" ]]; then
      write_curve "$profile" "$FULL_CURVE"
      echo "Full speed already engaged; reapplied to $profile"
      return 0
    fi
    # Engaged on a *different* profile -- `fan max` switching to Performance while the
    # override was held on Quiet, say. Put the old profile back before snapshotting this one,
    # or its curve stays overwritten with 100% for good and no snapshot remembers it.
    echo "Full speed was engaged on $(restore_snapshot); moving it to $profile"
  fi

  mkdir -p "$STATE_DIR" || die "cannot create $STATE_DIR"

  {
    printf '{"profile":"%s","fans":[' "$profile"
    while IFS='|' read -r id enabled data; do
      [[ -n "$id" && -n "$data" ]] || continue
      (( first )) || printf ','
      first=0
      printf '{"id":"%s","enabled":%s,"data":"%s"}' \
        "$id" "$([[ "$enabled" == "true" ]] && echo true || echo false)" "$data"
    done < <(curve_lines "$profile")
    printf ']}\n'
  } >"$SNAPSHOT"

  # A snapshot with no fans in it cannot restore anything; better to refuse than to overwrite
  # the curves and leave no way back.
  if ! grep -q '"id"' "$SNAPSHOT"; then
    rm -f "$SNAPSHOT"
    die "could not read the current curves; refusing to engage full speed"
  fi

  write_curve "$profile" "$FULL_CURVE"
  echo "Full speed engaged on $profile (previous curve saved)"
}

snapshot_profile() {
  [[ -s "$SNAPSHOT" ]] || return 1
  sed -n 's/.*"profile":"\([^"]*\)".*/\1/p' "$SNAPSHOT"
}

# Puts the snapshotted curves back into the profile they were taken from and clears the
# snapshot. Restores into that profile rather than the active one: `power` may have switched
# profiles since, and the curves that were overwritten belong to the old one.
restore_snapshot() {
  local profile id data enabled
  profile=$(snapshot_profile)
  [[ -n "$profile" ]] || die "snapshot at $SNAPSHOT names no profile; restore it by hand"

  while IFS='|' read -r id enabled data; do
    [[ -n "$id" && -n "$data" ]] || continue
    asusctl fan-curve --mod-profile "$profile" --fan "$id" --data "$data" >/dev/null \
      || die "asusctl refused the saved curve for the $id fan; snapshot kept at $SNAPSHOT"
    asusctl fan-curve --mod-profile "$profile" --fan "$id" --enable-fan-curve "$enabled" >/dev/null \
      || die "asusctl could not restore the enabled flag for the $id fan; snapshot kept at $SNAPSHOT"
  done < <(grep -o '{"id":"[^"]*","enabled":[a-z]*,"data":"[^"]*"}' "$SNAPSHOT" \
            | sed 's/{"id":"\([^"]*\)","enabled":\([a-z]*\),"data":"\([^"]*\)"}/\1|\2|\3/')

  rm -f "$SNAPSHOT"
  printf '%s' "$profile"
}

cmd_full_off() {
  require_asusctl

  if [[ ! -s "$SNAPSHOT" ]]; then
    echo "Full speed is not engaged"
    return 0
  fi

  echo "Full speed released; $(restore_snapshot) curve restored"
}

# --- profiles ---------------------------------------------------------------

# Profile switching goes through power-profiles-daemon, not asusctl. Both end up writing the
# same platform_profile, but PPD does not notice writes made behind its back: `power` then
# short-circuits on `powerprofilesctl get` and skips a change it believes it already applied,
# leaving the machine on a profile nobody asked for. Keeping PPD authoritative keeps the two
# tools agreeing. asusctl remains the fallback if PPD is not running.
set_profile() {
  local asus_name="$1" ppd_name=""

  case "$asus_name" in
    Quiet) ppd_name="power-saver" ;;
    Balanced) ppd_name="balanced" ;;
    Performance) ppd_name="performance" ;;
  esac

  if [[ -n "$ppd_name" ]] && command -v powerprofilesctl >/dev/null 2>&1; then
    if powerprofilesctl set "$ppd_name" 2>/dev/null; then
      confirm_profile "$asus_name"
      return 0
    fi
    echo "fan: powerprofilesctl could not set '$ppd_name'; falling back to asusctl" >&2
  fi

  asusctl profile set --ac --battery "$asus_name" >/dev/null || die "could not set the $asus_name profile"
  confirm_profile "$asus_name"
}

# Callers act on the profile that is active *now* -- `fan max` snapshots and overwrites its
# curves immediately after switching. If the switch has not landed yet, that work lands on the
# previous profile instead and silently overwrites a curve nobody meant to touch. Waiting for
# platform_profile to agree is what makes the sequencing safe.
confirm_profile() {
  local want="$1" i
  for i in 1 2 3 4 5 6 7 8 9 10; do
    [[ "$(asus_profile 2>/dev/null)" == "$want" ]] && return 0
    sleep 0.1
  done
  die "asked for the $want profile but the system still reports $(asus_profile 2>/dev/null); refusing to continue"
}

running_on_ac() {
  local supply
  for supply in /sys/class/power_supply/*; do
    [[ -r $supply/type && -r $supply/online ]] || continue
    [[ $(<"$supply/type") == "Mains" && $(<"$supply/online") == "1" ]] && return 0
  done
  return 1
}

cmd_status() {
  local asus core id input rpm gpu
  asus=$(hwmon_by_name asus)
  core=$(hwmon_by_name coretemp)
  gpu=$(gpu_temp)

  echo "profile:    $(platform_profile)"
  echo "cpu temp:   $(read_milli "$(cpu_temp_input "$core")")°C"
  echo "gpu temp:   ${gpu:+$gpu°C}${gpu:-unavailable (dGPU $(dgpu_status))}"
  for id in "${FANS[@]}"; do
    input=$(fan_input_for "$asus" "${id}_fan") || continue
    rpm=$(read_int "$input")
    printf '%s fan:    %s RPM\n' "$id" "${rpm:-unreadable}"
  done
  echo "full speed: $([[ -s "$SNAPSHOT" ]] && echo engaged || echo off)"
  if command -v asusctl >/dev/null 2>&1; then
    echo "curves:"
    asusctl fan-curve --get-enabled 2>/dev/null | sed 's/^/  /'
  fi
}

# --- dispatch ---------------------------------------------------------------

[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { usage; exit 0; }

case "${1:-status}" in
  status) cmd_status ;;
  sensors) cmd_sensors ;;
  hwmon) cmd_hwmon ;;
  curve)
    case "${2:-}" in
      get) cmd_curve_get ;;
      set) cmd_curve_set "${3:-}" ;;
      reset) cmd_curve_reset ;;
      "") die "curve needs a subcommand (get|set|reset)" 2 ;;
      *) die "unknown curve subcommand '${2}' (get|set|reset)" 2 ;;
    esac
    ;;
  full)
    case "${2:-}" in
      on) cmd_full_on ;;
      off) cmd_full_off ;;
      status) [[ -s "$SNAPSHOT" ]] && echo on || echo off ;;
      "") die "full needs on, off or status" 2 ;;
      *) die "unknown full argument '${2}' (on|off|status)" 2 ;;
    esac
    ;;
  slow)
    require_asusctl
    # Releasing first: "go quiet" while the fans are pinned flat out would be a contradiction,
    # and leaving the snapshot behind would strand the overridden profile's curve at 100%.
    [[ -s "$SNAPSHOT" ]] && echo "Releasing full speed on $(restore_snapshot)"
    set_profile Quiet
    echo "Fan mode: slow (Quiet)"
    ;;
  default)
    require_asusctl
    [[ -s "$SNAPSHOT" ]] && echo "Releasing full speed on $(restore_snapshot)"
    set_profile Balanced
    echo "Fan mode: default (Balanced)"
    ;;
  max)
    require_asusctl
    # Switch first, then engage: cmd_full_on snapshots whichever profile is active, and the
    # profile about to be overwritten is Performance.
    set_profile Performance
    cmd_full_on
    echo "Fan mode: max (Performance, 100% requested)"
    if ! running_on_ac; then
      echo "fan: ASUS firmware may cap fan speed while running on battery" >&2
    fi
    ;;
  *) die "unknown command '${1}' (try -h)" 2 ;;
esac
