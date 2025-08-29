function __dotfiles_setup_ansible {
    case $OS_DISTRO in
        ubuntu)
            ensure_install ansible
        ;;
        *)
            echo "Unsupported OS DISTRO: $OS_DISTRO" 1>&2
            exit 1
        ;;
    esac

}
