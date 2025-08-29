function __dotfiles_setup_libvirt {
    case $OS_DISTRO in
        ubuntu)
            ensure_install qemu-kvm libvirt-daemon-system
            if ! groups | grep -q libvirt; then
                sudo adduser $USER libvirt
            fi
        ;;
        *)
            echo "Unsupported OS DISTRO: $OS_DISTRO" 1>&2
            exit 1
        ;;
    esac

}

