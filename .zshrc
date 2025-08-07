zstyle ':z4h:'                   auto-update            'ask'
zstyle ':z4h:'                   auto-update-days       '28'
zstyle ':z4h:bindkey'            keyboard               'mac'
zstyle ':z4h:'                   start-tmux             no
zstyle ':z4h:'                   term-shell-integration 'yes'
zstyle ':z4h:autosuggestions'    forward-char           'accept'
zstyle ':z4h:fzf-complete'       recurse-dirs           'yes'
zstyle ':z4h:direnv'             enable                 'no'
zstyle ':z4h:direnv:success'     notify                 'yes'
zstyle ':z4h:ssh:*'              enable                 'yes'
# zstyle ':z4h:ssh:*'              send-extra-files       '~/.zsh_docker'
zstyle ':completion:*'           matcher-list           'm:{a-z}={A-Z}'
zstyle ':completion::complete:*' gain-privileges        1

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

path=(~/bin $path)

# Export environment variables.
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
export HOMEBREW_NO_ENV_HINTS=1
export PRISMA_HIDE_UPDATE_MESSAGE=1
export MANOPT=--no-hyphenation
export MANWIDTH='100'
export MANPAGER='nvim +Man!'
export NPM_CONFIG_INIT_LICENSE='GPL-3.0'
export NPM_CONFIG_INIT_VERSION='0.0.0'
export NPM_CONFIG_SIGN_GIT_TAG='true'
export LESSCHARSET=utf-8
export DO_NOT_TRACK=1
export FZF_DEFAULT_COLORS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
export FZF_DEFAULT_OPTS="\
  $FZF_DEFAULT_COLORS \
  --no-multi \
  --layout='reverse' \
  --info='inline' \
  --no-bold \
  --bind='ctrl-f:half-page-down' \
  --bind='ctrl-b:half-page-up'"

z4h bindkey undo Ctrl+/   Shift+Tab  # undo the last command line change
z4h bindkey redo Option+/            # redo the last undone command line change
z4h bindkey z4h-cd-back    Shift+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Shift+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Shift+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Shift+Down   # cd into a child directory

# Autoload functions.
autoload -Uz zmv

# Define functions and completions.
() {
  local hist
  for hist in ~/.zsh_history*~$HISTFILE(N); do
    fc -RI $hist
  done
}

function vim-foreground-background () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line -w
  else
    zle push-input -w
    zle clear-screen -w
  fi
}

zle -N vim-foreground-background
z4h bindkey vim-foreground-background Ctrl+Z

function mcd() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories mcd
compdef _default     open

function ghv() {
  gh repo view --web --branch $(git rev-parse --abbrev-ref HEAD)
}

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Define aliases.
if which nvim >/dev/null 2>&1; then
	alias :e="nvim ."
	alias vi="nvim"
	alias vim="nvim"
fi

alias :z="open . -a \"Zed\""
alias :c="open . -a \"Cursor\""
alias co="open . -a \"Visual Studio Code\""
alias cu="open . -a \"Cursor\""
alias tree='tree -a -I .git'

if which eza >/dev/null 2>&1; then
	alias ls="eza --color=always --icons=always --git --group-directories-first --hyperlink"
fi

alias lsa="${aliases[ls]:-ls} -a"
alias lsd="${aliases[ls]:-ls} -d .*"
alias ll="${aliases[ls]:-ls} --long -F -o --no-user -h --icons=never"

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
alias gpgfix="export GPG_TTY=$(tty)"
alias oo="open ."
alias speedtest='bunx fast-cli -u --single-line'
alias myip='ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d\  -f2'
alias mv='mv -iv' # Move nodes with interactive mode and extra verbosity.
alias ln='ln -iv' # Link nodes with interactive mode and extra verbosity.
alias g="git"
compdef g='git'

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu
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
setopt multios              # Write to multiple descriptors.
setopt extended_glob        # Use extended globbing syntax.
setopt clobber              # Turn off warning "file exists" with > and >>

unsetopt LIST_BEEP # disable bell when listing completions
unsetopt BEEP      # disable bell

unsetopt auto_name_dirs    # Auto add variable-stored paths to ~ list.
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

# z
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

if [[ -f "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi

if type brew &>/dev/null; then
	FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  fpath+=~/.zfunc
	autoload -Uz compinit
	compinit
fi

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

export PATH="/Users/pnodet/.bun/bin:$PATH"
export PATH="$(brew --prefix llvm@19)/bin:$PATH"

# Use Homebrew LLVM for C/C++ compilation
export CC="$(brew --prefix llvm@19)/bin/clang"
export CXX="$(brew --prefix llvm@19)/bin/clang++"

# fnm
export PATH="~/Library/Application Support/fnm:$PATH"
if (( $+commands[fnm] )); then
	eval "$(fnm env --use-on-cd)"
fi

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix

if [[ -f "$HOME/.local/bin/env" ]]; then
  . "$HOME/.local/bin/env"
fi
