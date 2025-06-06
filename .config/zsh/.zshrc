export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export ZSH="$HOME/.config/oh-my-zsh"
export MANPATH="/usr/local/man:$MANPATH"

# ENABLE_CORRECTION="true"
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="false"
ZSH_THEME="skill"
DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"
HISTSIZE=100000
SAVEHIST=100000

VI_MODE_SET_CURSOR=true
VI_MODE_CURSOR_INSERT=2
VI_MODE_CURSOR_NORMAL=6
# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
  sudo
  emoji
  colored-man-pages
  zsh-autosuggestions
  zsh-completions
  history-substring-search
  forgit
  vi-mode
)


## Options section
setopt nocheckjobs                 # Don't warn about running processes when exiting
setopt numericglobsort             # Sort filenames numerically when it makes sense
setopt appendhistory               # Immediately append history instead of overwriting
setopt histignorealldups           # If a new command is a duplicate, remove the older one
# zstyle ':completion:*' rehash true # automatically find new executables in path
zstyle ':completion:*' menu yes select

# Setup a custom completions directory

WORDCHARS=${WORDCHARS//\/[&.;]/}   # Don't consider certain characters part of the word

# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/zcompcache


## Keybindings section
bindkey -v
bindkey '^H' backward-kill-word # delete previous word with ctrl+backspace
bindkey '^z' undo
bindkey '^b' backward-word
bindkey '^w' forward-word # ctrl+backspace
bindkey '5~' kill-word    # ctrl+del


fpath=($HOME/.local/share/zsh/completions $fpath)


bindkey '^ ' autosuggest-accept

zmodload zsh/terminfo
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

[[ -f "$ZSH/oh-my-zsh.sh" ]] && . "$ZSH/oh-my-zsh.sh"

source <(fzf --zsh)

autoload compinit && compinit -i -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
unalias l
[[ -f "${XDG_CONFIG_HOME}/aliasrc" ]] && . "${XDG_CONFIG_HOME}/aliasrc"
[[ -f "${XDG_CONFIG_HOME}/bookmarkrc" ]] && . "${XDG_CONFIG_HOME}/bookmarkrc"


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/skill/.local/share/sdkman"
[[ -s "/home/skill/.local/share/sdkman/bin/sdkman-init.sh" ]] && source "/home/skill/.local/share/sdkman/bin/sdkman-init.sh"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
bindkey -M vicmd '^e' edit-command-line

