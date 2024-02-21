# ~/.zshrc: Executed by Zsh for interactive shells.

# If not running interactively, don't do anything
[[ -o interactive ]] || return

# Set history size
HISTSIZE=1000
SAVEHIST=2000

# Append to history, don't overwrite it
setopt append_history

# Don't put duplicate lines in the history
setopt hist_ignore_dups

# Check the window size after each command and update the values of LINES and COLUMNS
setopt checkwinsize

# Enable extended globbing
setopt extended_glob

# Configure PATH (Add your custom paths here, macOS doesn't have /usr/bin/dircolors by default)
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# Load zsh completions
autoload -Uz compinit
compinit

# Set prompt (customize as needed)
PROMPT='%n@%m:%~%# '

# If this is a terminal, set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
        PROMPT='%{$terminfo[bold]$fg[green]%}%n@%m%{$reset_color%}:%{$fg[cyan]%}%~%{$reset_color%}%# '
        ;;
esac

# Alias definitions
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias for vim to nvim, adjust as needed if Neovim is installed
alias vim='nvim'

# Alias python to python3, ensure Python 3 is installed and available in PATH
alias python='python3'

# Set Java home, adjust JAVA_HOME as needed based on your Java installation
export JAVA_HOME=$(/usr/libexec/java_home)

# Configure Go paths, adjust as needed based on your Go installation
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Source Cargo env, adjust as needed if Rust is installed
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Start tmux on shell login if it's not already running, adjust as needed
if [[ -z "$TMUX" ]] && command -v tmux &> /dev/null; then
	exec tmux
fi

# Note: macOS uses `launchctl` for services instead of System V or systemd init systems, so you might need to adjust service-related commands accordingly.

