function __dotfiles_setup_tmux {
    # install tmux
    case $OS_DISTRO in
        macos)
            ensure_install tmux
        ;;
        ubuntu)
            ensure_install tmux
        ;;
        arch)
            ensure_install tmux
        ;;
        *)
            echo "Unsupported OS DISTRO: $OS_DISTRO" 1>&2
            exit 1
        ;;
    esac

    # initialize submodules
    git submodule init
    git submodule update
    (cd ./tmux/.config/tmux/ && git submodule init && git submodule update)
}

