alias ls="ls --color"
alias ll="ls --color -al"
alias lg="lazygit"

alias pn="pnpm"
alias ff="fvm flutter"

if [[ $TMUX ]]; then
  alias clear="clear && tmux clear-history"
fi

export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home"

export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

export FVM_CACHE_PATH="$HOME/.fvm"

# export dart for global packages
export PATH="$PATH":"$FVM_CACHE_PATH/default/bin/cache/dart-sdk/bin"

# export global dart packages
export PATH="$PATH":"$HOME/.pub-cache/bin"

export PATH="$HOME/.shorebird/bin:$PATH"

# zsh-completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh 

bindkey "^[[Z" autosuggest-accept

bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

# Set up fzf key bindings and fuzzy completion
# export FZF_DEFAULT_OPTS=" \
# --color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
# --color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
# --color=marker:#babbf1,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284 \
# --color=selected-bg:#51576d \
# --multi"
source <(fzf --zsh)

eval "$(starship init zsh)"
