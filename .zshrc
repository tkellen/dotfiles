export PATH=${PATH}:${HOME}/go/bin:${HOME}/.cargo/bin
export EDITOR=code
# don't download terraform plugins everywhere
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

# enable emacs-style control
set -o emacs

# style prompt
source <(/usr/bin/starship init zsh --print-full-init)
autoload -U promptinit; promptinit

# enable shell completions
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
setopt COMPLETE_ALIASES
source <(kubectl completion zsh)

# pipe to clipboard easily
alias clip="xclip -in -selection clipboard"
alias wip="git add -A && git commit -m \"wip $(date)\" && git push origin"
# use "k" for running kubectl faster (and ensure completions work too)
alias k="kubectl"
compdef k="kubectl"

# command history configuration.
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history # Append existing history file rather than replacing.
setopt extended_history # Puts more info in the history file.
setopt hist_expire_dups_first # Remove duplicates from command history as it fills up.
setopt hist_ignore_dups # Ignore duplicated lines, like typing `ls` twice in a row.
setopt hist_ignore_space # Commands which begin with a space will not be recorded in history.
setopt hist_verify # Rather than executing commands loaded by history substitution, put them on the line to be executed.
setopt inc_append_history # Add commands to history immediately after execution (not when shell exits).
setopt share_history # Share command history data across terminals.
bindkey '^[[A' up-line-or-search # Search history matching current input
bindkey '^[[B' down-line-or-search # Search history matching current input

# write out all credentials to ~/.ssh and ~/.aws
function load-root-creds {
  LPASS_DISABLE_PINENTRY=1 lpass login tyler@wescaleout.com
  mkdir -p ~/.aws ~/.ssh
  chmod 644 ~/.ssh/*.pem ~/.ssh/id_rsa
  lpass ls tyler@goingslowly.com/Root | grep -oP '(?<=id: )([0-9]+)' | xargs -I{} -n1 bash -c 'lpass show {} --notes > $(eval echo $(lpass show --name {}))'
  chmod 400 ~/.ssh/*.pem ~/.ssh/id_rsa
}

source ~/.secrets