function __dotfiles_setup_vagrant {
    case $OS_DISTRO in
        ubuntu)
            if [ ! -f /etc/apt/sources.list.d/hashicorp.list ]; then
                # install Hashicorp's apt repo
                curl -q https://apt.releases.hashicorp.com/gpg | \
                    sudo gpg --dearmor \
                    -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | \
                    sudo tee /etc/apt/sources.list.d/hashicorp.list
            fi
            ensure_install vagrant libvirt-dev
        ;;
        *)
            echo "Unsupported OS DISTRO: $OS_DISTRO" 1>&2
            exit 1
        ;;
    esac

    if ! vagrant plugin list | grep -q vagrant-hostmanager; then
        vagrant plugin install vagrant-hostmanager
    fi

    if ! vagrant plugin list | grep -q vagrant-libvirt; then
        vagrant plugin install vagrant-libvirt
    fi

}


