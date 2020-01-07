# environment variables
export JAVA_HOME=/opt/jdk-12.0.2
export PATH=${JAVA_HOME}/bin:${PATH}:${HOME}/go/bin
export EDITOR=vim

# shell decoration
source <(antibody init)
autoload -U promptinit; promptinit
antibody bundle denysdovhan/spaceship-prompt
spaceship_vi_mode_disable

# enable shell completions
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
setopt COMPLETE_ALIASES
source <(kubectl completion zsh)

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

# workstation
function workstation {
  local left="0x0"
  local right="3840x0"
  if [[ "$#" -ne 0 ]]; then
    DP1=$right
    DP2=$left
  else
    DP1=$left
    DP2=$right
  fi
  xrandr \
    --output eDP-1 --off \
    --output DP-1-2 --primary --mode 3840x2160 --pos ${DP1} \
    --output DP-2-2 --mode 3840x2160 --pos ${DP2}
}

# write out all credentials to ~/.ssh and ~/.aws
function load-root-creds {
  LPASS_DISABLE_PINENTRY=1 lpass login tyler@scaleout.team
  mkdir -p ~/.aws ~/.ssh
  chmod 644 ~/.ssh/*.pem ~/.ssh/id_rsa
  lpass ls Root | grep -oP '(?<=id: )([0-9]+)' | xargs -I{} -n1 bash -c 'lpass show {} --notes > $(eval echo $(lpass show --name {}))'
  chmod 400 ~/.ssh/*.pem ~/.ssh/id_rsa
}

# some junk until i figure out what is up with openbox/intellij losing focus
function fij {
  xdotool windowactivate $(xdotool search --name intellij)
}

# connect to vpn using command saved in lastpass
function vpn {
  LPASS_DISABLE_PINENTRY=1 lpass login tyler@scaleout.team
  lpass show $1 --notes | zsh
}



