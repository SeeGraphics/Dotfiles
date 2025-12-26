typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)

source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Epic Quotes
if [[ -z ${_COWSAY_SHOWN-} ]]; then
  fortune | cowsay | lolcat
  typeset -g _COWSAY_SHOWN=1
fi

# User configuration
# Telescope-like file picker
f() {
  local file
  file=$(fd --type f . ~ | fzf --preview='bat --style=numbers --color=always {}' --height=80%)
  [[ -n "$file" ]] && nvim "$file"
}

# Telescope-like directory picker
d() {
  local dir
  dir=$(fd --type d . ~ | fzf --preview='ls --color=always {}' --height=80%)
  [[ -n "$dir" ]] && cd "$dir"
}

eval "$(zoxide init zsh)"

# Set Homebrew binary path
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"


# Add all Homebrew includes/libs for compilers
for dir in /opt/homebrew/opt/*; do
    if [[ -d "$dir/include" ]]; then
        export CPATH="$dir/include:$CPATH"
    fi
    if [[ -d "$dir/lib" ]]; then
        export LIBRARY_PATH="$dir/lib:$LIBRARY_PATH"
    fi
done

# Add Homebrew pkg-config paths
export PKG_CONFIG_PATH="/opt/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH"


# Preferred editor for local and remote sessions
export EDITOR='vim'

# Set compilation flags for macOS (if needed)
export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.

# Set terminal color variables
export TERM="xterm-256color"
export COLORTERM="truecolor"

# Vim alias
alias vim="nvim"
export EDITOR="nvim"
export VISUAL="nvim"

export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export DYLD_LIBRARY_PATH=/opt/homebrew/lib:$DYLD_LIBRARY_PATH
alias tmux="tmux -f ~/.tmux.conf"
eval "$(zoxide init zsh)"




# Added by Windsurf
export PATH="/Users/matteoheck/.codeium/windsurf/bin:$PATH"
