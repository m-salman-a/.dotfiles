alias ls="ls --color -l"
alias flutter="fvm flutter"

if [[ $TMUX ]]; then
  alias clear="clear && tmux clear-history"
fi

export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-17.jdk"
export PATH="$(brew --prefix)/opt/openjdk@17/bin:$PATH"

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

# Autocompletion
bindkey '^[[Z' autosuggest-accept

# Substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

eval "$(starship init zsh)"
