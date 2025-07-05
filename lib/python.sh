function __dotfiles_setup_python {
    case $OS_DISTRO in
        macos)
            ensure_install python3
        ;;
        ubuntu)
            ensure_install python3-venv
        ;;
        arch)
            echo "All set"
        ;;
        *)
            echo "Unsupported OS DISTRO: $OS_DISTRO" 1>&2
            exit 1
        ;;
    esac
}

