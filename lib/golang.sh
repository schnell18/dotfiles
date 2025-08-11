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
    ensure_go_cmd_installed \
        dlv \
        "github.com/go-delve/delve/cmd/dlv@latest"

    # gofumpt
    ensure_go_cmd_installed \
        gofumpt \
        "mvdan.cc/gofumpt@latest"

    # goimports
    ensure_go_cmd_installed \
        goimports \
        "golang.org/x/tools/cmd/goimports@latest"

    # goimports-reviser
    ensure_go_cmd_installed \
        goimports-reviser \
        "github.com/incu6us/goimports-reviser/v3@latest"

    # golines
    ensure_go_cmd_installed \
        golines \
        "github.com/segmentio/golines@latest"

    # gomodifytags
    ensure_go_cmd_installed \
        gomodifytags \
        "github.com/fatih/gomodifytags@latest"

    # gotests
    ensure_go_cmd_installed \
        gotests \
        "github.com/cweill/gotests/gotests@latest"

    # gotestsum
    ensure_go_cmd_installed \
        gotestsum \
        "gotest.tools/gotestsum@latest"

    # setup PATH
    ensure_go_utils_in_path
}

ensure_go_cmd_installed() {
    cmd_name=$1
    cmd_url=$2

    if ! command -v $cmd_name &>/dev/null; then
        echo "Setup ${cmd_name}..."
        go install $cmd_url
    fi
}

ensure_go_utils_in_path() {
  if ! grep -q 'export PATH="$HOME/go/bin:$PATH"' "$HOME/.bashrc" 2>/dev/null; then
    echo 'export PATH="$HOME/go/bin:$PATH"' >>"$HOME/.bashrc"
    echo "Added go utils to PATH in ~/.bashrc"
    echo "Relaunch bash to take effect!!!"
  fi
  if ! grep -q 'export PATH="$HOME/go/bin:$PATH"' "$HOME/.zshrc" 2>/dev/null; then
    echo 'export PATH="$HOME/go/bin:$PATH"' >>"$HOME/.zshrc"
    echo "Added go utils to PATH in ~/.zshrc"
    echo "Relaunch zsh to take effect!!!"
  fi
}

