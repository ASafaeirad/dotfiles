export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export ZSH="$HOME/.config/oh-my-zsh"

ZSH_THEME="skill"
DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"
HISTSIZE=1000
SAVEHIST=1000

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
  sudo
  nvm
  emoji
  colored-man-pages
  zsh-autosuggestions
  zsh-completions
  history-substring-search
	forgit
)

## Options section
setopt nocheckjobs                 # Don't warn about running processes when exiting
setopt numericglobsort             # Sort filenames numerically when it makes sense
setopt appendhistory               # Immediately append history instead of overwriting
setopt histignorealldups           # If a new command is a duplicate, remove the older one
zstyle ':completion:*' rehash true # automatically find new executables in path
WORDCHARS=${WORDCHARS//\/[&.;]/}   # Don't consider certain characters part of the word

# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

## Keybindings section
bindkey -e
bindkey '^H' backward-kill-word # delete previous word with ctrl+backspace
bindkey '^z' undo
bindkey '^b' backward-word
bindkey '^w' forward-word # ctrl+backspace
bindkey '5~' kill-word    # ctrl+del

autoload -U compinit && compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
bindkey '^ ' autosuggest-accept

zmodload zsh/terminfo
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

[[ -f "$ZSH/oh-my-zsh.sh" ]] && . "$ZSH/oh-my-zsh.sh"
[[ -f "${XDG_CONFIG_HOME}/aliasrc" ]] && . "${XDG_CONFIG_HOME}/aliasrc"

