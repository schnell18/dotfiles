function __dotfiles_setup_golang {
    local requested_version="${GO_VERSION:-1.25.7}"

    # Detect OS and architecture
    local os arch
    case "$(uname)" in
        Darwin) os="darwin" ;;
        Linux)  os="linux" ;;
        *)      echo "Unsupported OS: $(uname)" >&2; exit 1 ;;
    esac
    case "$(uname -m)" in
        x86_64)        arch="amd64" ;;
        aarch64|arm64) arch="arm64" ;;
        *)             echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
    esac

    # Check installed version
    local installed_version=""
    if command -v go &>/dev/null; then
        installed_version=$(go version | sed -n 's/.*go\([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\).*/\1/p')
    fi

    __go_reinstalled=false
    if [[ "$installed_version" == "$requested_version" ]]; then
        echo "Go $requested_version is already installed, skipping."
    else
        if [[ -n "$installed_version" ]]; then
            echo "Go version mismatch: installed=$installed_version, requested=$requested_version"
            echo "Replacing with Go $requested_version..."
        else
            echo "Installing Go $requested_version..."
        fi
        local tarball="go${requested_version}.${os}-${arch}.tar.gz"
        curl -L "https://go.dev/dl/${tarball}" -o "/tmp/${tarball}"
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local/ -xzf "/tmp/${tarball}"
        sudo ln -sf /usr/local/go/bin/go /usr/local/bin/go
        rm -f "/tmp/${tarball}"
        __go_reinstalled=true
        echo "Go $requested_version installed successfully."
    fi

    ensure_install bison

    # gopls
    ensure_go_cmd_installed \
        gopls \
        "golang.org/x/tools/gopls@latest"

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

    # golangci-lint
    ensure_go_cmd_installed \
        golangci-lint \
        "github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v2.3.1"

    # setup PATH
    ensure_go_utils_in_path
}

ensure_go_cmd_installed() {
    cmd_name=$1
    cmd_url=$2
    build_tags=$3

    if ! command -v $cmd_name &>/dev/null; then
        echo "Setup ${cmd_name}..."
        if [ -z $build_tags ]; then
            go install $cmd_url
        else
            go install --tags "$build_tags" $cmd_url
        fi
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

