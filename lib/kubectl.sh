function __dotfiles_setup_kubectl {
    KUBE_VER=$KUBERNETES_VERSION
    if [[ -z $KUBE_VER ]]; then
        KUBE_VER="v1.31"
    fi
    case $OS_DISTRO in
        ubuntu)
            if [ ! -f /etc/apt/sources.list.d/kubernetes.list ]; then
                # install kubernetes apt repo
                curl -fsSL "https://pkgs.k8s.io/core:/stable:/$KUBE_VER/deb/Release.key" | \
                    sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-apt-keyring.gpg
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBE_VER/deb/ /" | \
                    sudo tee /etc/apt/sources.list.d/kubernetes.list
            fi
            ensure_install kubectl
        ;;
        *)
            echo "Unsupported OS DISTRO: $OS_DISTRO" 1>&2
            exit 1
        ;;
    esac

    if ! grep -q "alias k=kubectl" $HOME/.bashrc; then
        echo "alias k=kubectl" >> $HOME/.bashrc
        echo 'complete -o default -F __start_kubectl k' >> $HOME/.bashrc
        echo 'source <(kubectl completion bash)' >> $HOME/.bashrc
    fi

    if ! grep -q "alias k=kubectl" $HOME/.zshrc; then
        echo "alias k=kubectl" >> $HOME/.zshrc
        echo 'complete -o default -F __start_kubectl k' >> $HOME/.zshrc
        echo 'source <(kubectl completion zsh)' >> $HOME/.zshrc
    fi
}
