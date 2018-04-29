alias k="kubectl"
alias ka="k apply -f"
alias kg="k get"
alias kd="k describe"
alias kl="k logs"
alias ke="k exec"
alias ks="k --namespace=kube-system"
alias kbb="k run -i --tty busybox --image=busybox --restart=Never --rm -- sh"

# ensure k alias completes using kubectl completions
compdef k='kubectl'
