zstyle ':z4h:' auto-update      'ask'
zstyle ':z4h:' auto-update-days '28'
zstyle ':z4h:bindkey' keyboard  'mac'
zstyle ':z4h:' start-tmux       no
zstyle ':z4h:' term-shell-integration 'yes'
zstyle ':z4h:autosuggestions' forward-char 'accept'
zstyle ':z4h:fzf-complete' recurse-dirs 'yes'
zstyle ':z4h:direnv'         enable 'no'
zstyle ':z4h:direnv:success' notify 'yes'

zstyle ':z4h:ssh:*'                   enable 'yes'
zstyle ':z4h:ssh:*' send-extra-files '~/.zsh_docker'

# complete case insensitive (https://stackoverflow.com/questions/13424429/can-zsh-do-smartcase-completion-like-vims-search)
zstyle ':completion:*'  matcher-list 'm:{a-z}={A-Z}'

# complete sudo commands
zstyle ':completion::complete:*' gain-privileges 1

z4h init || return

path=(~/bin $path)

if [[ -z "$LANG" ]]; then
	export LANG='en_US.UTF-8'
	export LANGUAGE=en_US.UTF-8
fi

export GPG_TTY=$TTY
export EDITOR="nvim"
export LC_COLLATE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_MONETARY=en_US.UTF-8
export LC_NUMERIC=en_US.UTF-8
export LC_TIME=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LESSCHARSET=utf-8
export HOMEBREW_NO_ENV_HINTS=1

z4h source ~/.zsh_docker

z4h bindkey undo Ctrl+/   Shift+Tab  # undo the last command line change
z4h bindkey redo Option+/            # redo the last undone command line change

z4h bindkey z4h-cd-back    Shift+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Shift+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Shift+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Shift+Down   # cd into a child directory

vim-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line -w
  else
    zle push-input -w
    zle clear-screen -w
  fi
}
zle -N vim-ctrl-z
z4h bindkey vim-ctrl-z Ctrl+Z

autoload -Uz zmv

function uuid() { uuidgen | tr -d - | tr -d '\n' | tr '[:upper:]' '[:lower:]' | pbcopy && pbpaste && echo }
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

alias :e=vim
if which nvim >/dev/null 2>&1; then
	alias vi=nvim
	alias vim=nvim
fi

alias tree='tree -a -I .git'

alias lsa="${aliases[ls]:-ls} -a"
alias lsd="${aliases[ls]:-ls} -d .*"
alias ll="${aliases[ls]:-ls} -lFh"

alias sudo='sudo '

alias apt="sudo apt"
alias aptitude="sudo aptitude"
alias pacman="sudo pacman"
alias systemctl="sudo systemctl"

alias \$=''

alias ..='cd ..'
alias ...='cd ../..'
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias cdd='dirs -v && read index && let "index=$index+0" && cd ~"$index" && let "index=$index+1" && popd -q +"$index"'

alias c='clear'
alias path='echo -e ${PATH//:/\\n}'
alias reload="exec zsh"
alias g="git"
alias gpgfix="export GPG_TTY=$(tty)"
alias oo="open ."
alias ogh="gh repo view --web"
alias co="code ."
alias speedtest='fast -u --single-line'
alias myip='ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d\  -f2'
alias brewup="brew update && brew upgrade && brew upgrade --cask && brew cleanup --prune=5 && brew doctor"

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt APPEND_HISTORY         # Allow multiple sessions to append to one Zsh command history.
setopt EXTENDED_HISTORY       # show timestamp in history ":start:elapsed;command"
setopt HIST_EXPIRE_DUPS_FIRST # allow dups, but expire old ones when exceeding HISTSIZE
setopt HIST_FIND_NO_DUPS      # do not find duplicates in history
setopt HIST_IGNORE_ALL_DUPS   # ignore duplicate commands
setopt HIST_IGNORE_DUPS       # ignore duplicate commands
setopt HIST_IGNORE_SPACE      # ignore entries starting with a space
setopt HIST_REDUCE_BLANKS     # leave blanks out
setopt HIST_SAVE_NO_DUPS      # do not save duplicates
setopt INC_APPEND_HISTORY     # write to the history file immediately, not when the shell exits
setopt SHARE_HISTORY          # share history between different instances of the shell

setopt auto_cd              # Auto changes to a directory without typing cd.
setopt auto_list            # Automatically list choices on ambiguous completion
setopt auto_pushd           # Push the old directory onto the stack on cd.
setopt bang_hist            # Treat the '!' character, especially during expansion
setopt interactive_comments # Comments even in interactive shells.
setopt pushd_ignore_dups    # Do not store duplicates in the stack.
setopt pushd_silent         # Do not print the directory stack after pushd or popd.
setopt pushd_to_home        # Push to home directory when no argument is given.
setopt cdable_vars          # Change directory to a path stored in a variable.
setopt auto_name_dirs       # Auto add variable-stored paths to ~ list.
setopt multios              # Write to multiple descriptors.
setopt extended_glob        # Use extended globbing syntax.
setopt clobber              # Turn off warning "file exists" with > and >>

unsetopt LIST_BEEP # disable bell when listing completions
unsetopt BEEP      # disable bell

unsetopt menu_complete     # do not autoselect the first completion entry
unsetopt flow_control      # disable start/stop characters in shell editor
unsetopt case_glob         # makes globbing (filename generation) case-sensitive

setopt always_to_end       # move cursor to the end of a completed word
setopt auto_menu           # show completion menu on a successive tab press
setopt auto_list           # automatically list choices on ambiguous completion
setopt auto_param_slash    # if completed parameter is a directory, add a trailing slash
setopt complete_in_word    # complete from both ends of a word
setopt extended_glob       # needed for file modification glob modifiers with compinit
setopt path_dirs           # perform path search even on command names with slashes
setopt globdots            # files beginning with a . be matched without explicitly specifying the dot

DISABLE_AUTO_TITLE="true"
tab_title() {
  # sets the tab title to current dir
  echo -ne "\e]1;${PWD##*/}\a"
}
add-zsh-hook precmd tab_title

# bun completions
[ -s "/Users/pnodet/.bun/_bun" ] && source "/Users/pnodet/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# fnm
export PATH="/Users/pnodet/Library/Application Support/fnm:$PATH"
if (( $+commands[fnm] )); then
	eval "$(fnm env --use-on-cd)"
fi

# z
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

if [[ -f "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi
