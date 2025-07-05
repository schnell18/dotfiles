function __dotfiles_setup_git {
    echo "Setting up git"

    # Install git and bash-completion
    case $OS_DISTRO in
        macos)
            ensure_install git bash-completion
        ;;
        ubuntu)
            ensure_install git bash-completion
        ;;
        arch)
            ensure_install git bash-completion
        ;;
        *)
            echo "Unsupported OS DISTRO: $OS_DISTRO" 1>&2
            exit 1
        ;;
    esac
}


