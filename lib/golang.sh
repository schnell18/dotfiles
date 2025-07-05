function __dotfiles_setup_golang {
    case $OS_DISTRO in
        macos)
            ensure_install bison go
        ;;
        ubuntu)
            ensure_install bison golang-go
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

    # gvm install go1.23
    # gvm use go1.23 --default
}

