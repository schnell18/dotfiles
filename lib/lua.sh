function __dotfiles_setup_lua {
    case $OS_DISTRO in
        macos)
            ensure_install luarocks
        ;;
        ubuntu)
            ensure_install luarocks
        ;;
        arch)
            ensure_install luarocks
        ;;
        *)
            echo "Unsupported OS DISTRO: $OS_DISTRO" 1>&2
            exit 1
        ;;
    esac
}

