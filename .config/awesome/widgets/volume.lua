local wibox = require("wibox")
local awful = require("awful")
local colors = require("modules.colors")

require("math")
require("string")

local volume = {}
volume.__index = volume

local function run(command)
    local prog = io.popen(command)
    local result = prog:read('*all')
    prog:close()
    return result
end

function volume:new(args)
    local obj = setmetatable({}, volume)
    obj.step = args.step or 5
    obj.device = args.device or "Master"
    obj.color = args.color or "white"
    obj.mute_color = args.mute_color or "red"

    obj.widget = wibox.widget {
        max_value = 100,
        thickness = 2,
        rounded_edge = true,
        start_angle = 4.71238898, -- 2pi*3/4
        forced_height = 12,
        forced_width = 12,
        paddings = 8,
        colros = { obj.color },
        widget = wibox.container.arcchart,
    }

    -- Add a tooltip to the imagebox
    obj.tooltip = awful.tooltip({
        timer_function = function()
            return obj:update_tooltip()
        end
    })
    obj.tooltip:add_to_object(obj.widget)

    obj.timer = timer({ timeout = 5 })
    obj.timer:connect_signal("timeout", function() obj:update() end)
    obj.timer:start()

    obj:update()

    return obj
end

function volume:update_tooltip()
    return string.sub(self:get_volume(), 0, 2) .. "% volume"
end

function volume:update()
    local value = self:get_volume()
    local is_muted = self:is_muted()

    if is_muted then
        self.widget.colors = { self.mute_color }
    else
        self.widget.colors = { self.color }
    end

    self.widget.value = value
end

function volume:up()
    run("pactl set-sink-volume @DEFAULT_SINK@" .. " +" .. self.step .. "%")
end

function volume:down()
    run("pactl set-sink-volume @DEFAULT_SINK@" .. " -" .. self.step .. "%")
end

function volume:mute()
    run("pactl set-sink-volume @DEFAULT_SINK@ toggle")
    self:update()
end

function volume:is_muted()
    local result = run("pactl get-sink-mute @DEFAULT_SINK@")
    return string.find(result, "yes")
end

function volume:get_volume()
    local result = run("pactl get-sink-volume @DEFAULT_SINK@")
    local percent = string.match(result, "%s+(%d+)%%")
    return string.gsub(percent, "%D", "")
end

return volume:new({
    step = 10,
    mute_color = colors.error,
    color = colors.fg
})
