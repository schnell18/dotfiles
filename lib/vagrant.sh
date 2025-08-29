function __dotfiles_setup_vagrant {
    case $OS_DISTRO in
        ubuntu)
            ensure_install vagrant vagrant-hostmanager vagrant-libvirt
        ;;
        *)
            echo "Unsupported OS DISTRO: $OS_DISTRO" 1>&2
            exit 1
        ;;
    esac

}


