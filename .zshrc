# use jdk 12 by default
export JAVA_HOME=/opt/jdk-12.0.2
export PATH=${JAVA_HOME}/bin:${PATH}:${HOME}/go/bin
export EDITOR=vim

# shell decoration
source <(antibody init)
autoload -U promptinit; promptinit
antibody bundle denysdovhan/spaceship-prompt
SPACESHIP_PROMPT_ORDER=(
  # time        # Time stamps section (Disabled)
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  aws           # Amazon Web Services section
  kubecontext   # Kubectl context section
  exec_time     # Execution time
  line_sep      # Line break
  battery       # Battery level and status
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)

# enable shell completions
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
setopt COMPLETE_ALIASES
source <(kubectl completion zsh)

# use "k" for running kubectl faster (and ensure completions work too)
alias k="kubectl"
compdef k="kubectl"

# generate openbox config for desired working mode before starting X
function start {
  local mode=${1}
  local root="${HOME}/.config/openbox"
  local modePath="${root}/mode"
  local modeFile="${modePath}/${mode}.xml"
  if [[ ! -f "${modeFile}" ]]; then
    printf "Invalid mode, try one of the following:\n"
    find ${modePath} -type f | xargs -n1 basename | cut -d'.' -f1 | sed 's/^/  /g'
  else
    # build openbox config for current working mode
    CONFIG=$(cat ${modeFile}) envsubst < ${root}/config.xml > ${root}/rc.xml
    WORKING_MODE=${mode} startx
  fi
}

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
  LPASS_DISABLE_PINENTRY=1 lpass login tyler@scaleout.team
  mkdir -p ~/.aws ~/.ssh
  chmod 644 ~/.ssh/*.pem ~/.ssh/id_rsa
  lpass ls Root | grep -oP '(?<=id: )([0-9]+)' | xargs -I{} -n1 bash -c 'lpass show {} --notes > $(eval echo $(lpass show --name {}))'
  chmod 400 ~/.ssh/*.pem ~/.ssh/id_rsa
}

# connect to vpn using command saved in lastpass
function vpn {
  LPASS_DISABLE_PINENTRY=1 lpass login tyler@scaleout.team
  lpass show $1 --notes | zsh
}



