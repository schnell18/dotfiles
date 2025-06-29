#!/bin/bash

function ensure_install {
    PKGS="$*"
    for PKG in $PKGS; do
        case $OS_DISTRO in
            macos)
                if ! brew list "$PKG" >/dev/null 2>&1; then
                    brew install "$PKG"
                fi
            ;;
            ubuntu)
                if ! dpkg -s "$PKG" >/dev/null 2>&1; then
                    sudo apt-get install -y "$PKG"
                fi
            ;;
            arch)
                if ! pacman -Q "$PKG" >/dev/null 2>&1; then
                    sudo pacman -S --noconfirm --needed "$PKG"
                fi
            ;;
            *)
                echo "Unsupported OS DISTRO: $OS_DISTRO" 1>&2
                exit 1
            ;;
        esac
    done
}

function get_os_dist {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        echo "$DISTRIB_ID"
    elif [ -f /etc/redhat-release ]; then
        echo "rhel"
    elif [ -f /etc/arch-release ]; then
        echo "arch"
    else
        echo "unknown"
    fi
}

function setup_golang {
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

function setup_lua {
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

function setup_node {
    if ! command -v node; then
        # Download and install nvm:
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

        # in lieu of restarting the shell
        . "$HOME/.nvm/nvm.sh"

        # Download and install Node.js:
        nvm install 22
    fi
}

function setup_git {
    echo "Setting up git"
    # The rest of function is intentionally left blank.
}

function setup_ghostty {
    case $OS_DISTRO in
        macos)
            ensure_install ghostty
        ;;
        ubuntu)
            ensure_install ghostty
        ;;
        arch)
            ensure_install ghostty
        ;;
        *)
            echo "Unsupported OS DISTRO: $OS_DISTRO" 1>&2
            exit 1
        ;;
    esac
}

function setup_tmux {
    # install tmux
    case $OS_DISTRO in
        macos)
            ensure_install tmux
        ;;
        ubuntu)
            ensure_install ghostty
        ;;
        arch)
            ensure_install ghostty
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

function setup_nvim {
    # install neovim
    case $OS_DISTRO in
        macos)
            ensure_install neovim ripgrep
        ;;
        ubuntu)
            if [[ ! -f /opt/nvim/bin/nvim ]]; then
                curl -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
                     -o /tmp/nvim-linux-x86_64.tar.gz
                sudo rm -rf /opt/nvim
                sudo tar -C /opt -xzf /tmp/nvim-linux-x86_64.tar.gz
                sudo mv /opt/nvim-linux-x86_64 /opt/nvim
                rm -f /tmp/nvim-linux-x86_64.tar.gz
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

function setup_python {
    case $OS_DISTRO in
        macos)
            ensure_install python3
        ;;
        ubuntu)
            ensure_install python3-venv
        ;;
        arch)
            echo "All set"
        ;;
        *)
            echo "Unsupported OS DISTRO: $OS_DISTRO" 1>&2
            exit 1
        ;;
    esac
}

function setup_r {
    # install R
    case $OS_DISTRO in
        macos)
            ensure_install R
        ;;
        ubuntu)
            ensure_install R
        ;;
        arch)
            ensure_install r
        ;;
        *)
            echo "Unsupported OS DISTRO: $OS_DISTRO" 1>&2
            exit 1
        ;;
    esac

    # install essential packages
    Rscript -e 'install.packages(c("languageserver"))'
}

# fail fast by exiting on first error
set -e
[[ -z $DEBUG_SETUP ]] || set -x

OS_DISTRO="macos"
_OS=$(uname)
case $_OS in
    Linux)
        OS_DISTRO=$(get_os_dist)
        if [[ $OS_DISTRO == "unknown" ]]; then
            echo "Unknown distribution" 1>&2
            exit 1
        fi
    ;;
    Darwin)
        OS_DISTRO="macos"
    ;;
    *)
        echo "Unsupported OS: $_OS" 1>&2
        exit 1
    ;;
esac

# ensure pre-requisite software are installed: stow, homebrew (MacOS only)
if [[ $OS_DISTRO == "macos" ]]; then
    if ! command -v brew; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
fi

if ! command -v stow; then
    ensure_install stow
fi

setup_funcs=$(grep -e "^function" $0 | cut -d' ' -f2)
comps="$*"
# Ensure node is installed
if [[ ! -d $HOME/.nvm ]]; then
    [[ ! $comps =~ "*node*" ]] && comps="node $comps"
fi
for comp in $comps; do
    # validate the component specified by user is supported
    setup_func="setup_$(echo $comp | tr '[:upper:]' '[:lower:]')"
    if ! echo $setup_funcs | grep -q -w $setup_func; then
        echo "$comp is not supported" 1>&2
        exit 1
    fi

    echo "=================================================="
    echo "= Setting up $comp...                             "
    echo "=================================================="
    [[ -d $comp ]] && stow $comp
    eval $setup_func
    echo "=================================================="
    echo "= $comp setup done!                               "
    echo "=================================================="
done
