function __dotfiles_setup_nvim {
    # install neovim
    case $OS_DISTRO in
        macos)
            ensure_install neovim ripgrep
        ;;
        ubuntu)
            if [[ ! -f /opt/nvim/bin/nvim ]]; then
                ARCH=$(uname -m)
                if [ $ARCH == "aarch64" ]; then
                    ARCH="arm64"
                fi
                curl -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${ARCH}.tar.gz \
                     -o /tmp/nvim-linux-${ARCH}.tar.gz
                sudo rm -rf /opt/nvim
                sudo tar -C /opt -xzf /tmp/nvim-linux-${ARCH}.tar.gz
                sudo mv /opt/nvim-linux-${ARCH} /opt/nvim
                rm -f /tmp/nvim-linux-${ARCH}.tar.gz
            fi
            ensure_install ripgrep
        ;;
        arch)
            ensure_install neovim ripgrep
        ;;
        *)
            echo "Unsupported OS DISTRO: $OS_DISTRO" 1>&2
            exit 1
        ;;
    esac
    git submodule init
    git submodule update
    (cd ./nvim/.config/nvim/ && git submodule init && git submodule update)
}
