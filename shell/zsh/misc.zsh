# quick picture of memory usage
alias mem='ps -eo pmem,pcpu,rss,vsize,args | sort -k 1 -r | less'
# Don't confuse zsh's globbing with rake arguments
alias rake='noglob rake'
# Nuke .DS_Store files recursively.
alias dsnuke="find . -name '*.DS_Store' -type f -ls -delete"
# get public key
alias pkey="pbcopy < ~/.ssh/id_rsa.pub"
# quick editor access
alias a="atom"
# use atom as default editor
export EDITOR=atom
