alias ls="ls --color -l"
alias flutter="fvm flutter"

if [[ $TMUX ]]; then
  alias clear="clear && tmux clear-history"
fi

export JAVA_HOME=`/usr/libexec/java_home -v 17`

export ANDROID_HOME="/Users/$USER/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

export GEM_HOME="$HOME/.gem"

export FVM_CACHE_PATH="$HOME/.fvm"

export PATH="$PATH":"$FVM_CACHE_PATH/default/bin/cache/dart-sdk/bin"
export PATH="$PATH":"$HOME/.pub-cache/bin"

export PATH="/Users/mohammadalfarisi/.shorebird/bin:$PATH"

export PATH="/opt/nvim/bin:$PATH"

# Zsh completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  # Git completions
  fpath=(~/.zsh $fpath)

  autoload -Uz compinit
  compinit
fi

source ~/.zsh/catppuccin_frappe-zsh-syntax-highlighting.zsh

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh 

# Autocompletion
bindkey '^[[Z' autosuggest-accept

# Substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

eval "$(starship init zsh)"
