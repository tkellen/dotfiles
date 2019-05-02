alias k="kubectl"
alias ks="kubectl --namespace=kube-system"
alias kbb="k run -i --tty busybox --image=busybox --restart=Never --rm -- sh"

# ensure k alias completes using kubectl completions
compdef k="kubectl"
compdef ks="kubectl"
