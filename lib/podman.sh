function __dotfiles_setup_podman {
    case $OS_DISTRO in
        macos)
            ensure_install podman
        ;;
        ubuntu)
            ensure_install podman
        ;;
        arch)
            ensure_install podman
        ;;
        *)
            echo "Unsupported OS DISTRO: $OS_DISTRO" 1>&2
            exit 1
        ;;
    esac

}

