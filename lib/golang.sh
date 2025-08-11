function __dotfiles_setup_golang {
    case $OS_DISTRO in
        macos)
            ensure_install bison go
        ;;
        ubuntu)
            ensure_install bison
            # latest golang tends to be dated, install a recent one
            if [[ ! -f /usr/local/go/bin/go ]]; then
                GO_VER="1.24.6"
                ARCH=$(uname -m)
                if [ $ARCH == "aarch64" ]; then
                    ARCH="arm64"
                elif [ $ARCH == "x86_64" ]; then
                    ARCH="amd64"
                fi
                GO_BIN_FILE_BASE_NAME=go${GO_VER}.linux-${ARCH}
                GO_BIN_FILE_NAME=${GO_BIN_FILE_BASE_NAME}.tar.gz
                curl -L https://go.dev/dl/${GO_BIN_FILE_NAME} \
                    -o /tmp/${GO_BIN_FILE_NAME}
                sudo rm -rf /usr/local/go
                sudo tar -C /usr/local/ -xzf /tmp/${GO_BIN_FILE_NAME}
                sudo mv /usr/local/${GO_BIN_FILE_BASE_NAME} /usr/local/go
                sudo ln -sf /usr/local/go/bin/go /usr/local/bin/go
                rm -f /tmp/${GO_BIN_FILE_NAME}
            fi
        ;;
        arch)
            ensure_install bison go
        ;;
        *)
            echo "Unsupported OS DISTRO: $OS_DISTRO" 1>&2
            exit 1
        ;;
    esac
    # Download and install gvm:
    if [[ ! -d $HOME/.gvm ]]; then
        bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
    fi

    # delve
    go install github.com/go-delve/delve/cmd/dlv@latest
    # gofumpt
    go install mvdan.cc/gofumpt@latest
    # goimports
    go install golang.org/x/tools/cmd/goimports@latest
    # goimports-reviser
    go install -v github.com/incu6us/goimports-reviser/v3@latest
    # golines
    go install github.com/segmentio/golines@latest
    # gomodifytags
    go install github.com/fatih/gomodifytags@latest
    # gotests
    go install github.com/cweill/gotests/gotests@latest
    # gotestsum
    go install gotest.tools/gotestsum@latest

}

