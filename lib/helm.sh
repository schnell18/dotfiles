function __dotfiles_setup_helm {
    case $OS_DISTRO in
        ubuntu)

            if [ ! -f /etc/apt/sources.list.d/helm.list ]; then
                # install helm apt repo
                curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | \
                    sudo tee /usr/share/keyrings/helm.gpg > /dev/null
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm.list
            fi
            ensure_install helm
        ;;
        *)
            echo "Unsupported OS DISTRO: $OS_DISTRO" 1>&2
            exit 1
        ;;
    esac

}
