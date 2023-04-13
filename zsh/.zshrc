HOMEBREW_PREFIX=/opt/homebrew/share
source $HOMEBREW_PREFIX/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOMEBREW_PREFIX/zsh-history-substring-search/zsh-history-substring-search.zsh 

# Brew completions
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

# Git completions
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

# Autocompletion
bindkey '^[[Z' autosuggest-accept	   

# Substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

eval "$(starship init zsh)"

colorscript random
