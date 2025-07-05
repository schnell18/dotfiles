function __dotfiles_setup_ghostty {
    case $OS_DISTRO in
        macos)
            ensure_install ghostty
        ;;
        ubuntu)
            ensure_install ghostty
        ;;
        arch)
            ensure_install ghostty
        ;;
        *)
            echo "Unsupported OS DISTRO: $OS_DISTRO" 1>&2
            exit 1
        ;;
    esac
}

