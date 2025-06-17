#!/bin/bash

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

function setup_git {
    echo "Setting up git"
    # The rest of function is intentionally left blank.
}

function setup_ghostty {
    case $OS_DISTRO in
        macos)
            brew install ghostty
        ;;
        ubuntu)
            apt-get install -y ghostty
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
            brew install tmux
        ;;
        ubuntu)
            apt-get install -y tmux
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
            brew install neovim ripgrep
        ;;
        ubuntu)
            apt-get install -y neovim ripgrep
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
            brew install R
        ;;
        ubuntu)
            apt-get install -y R
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

# ensure pre-requisite software are installed: homebrew, stow
ret=$(command -v stow)
if [[ $? -ne 0 ]]; then
    brew install stow
fi

ret=$(command -v brew)
if [[ $? -ne 0 ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

setup_funcs=$(grep -e "^function" $0 | cut -d' ' -f2)
for comp in $@; do
    # validate the component specified by user is supported
    setup_func="setup_$(echo $comp | tr '[:upper:]' '[:lower:]')"
    ret=$(echo $setup_funcs | grep -q -w $setup_func)
    if [[ $? -ne 0 ]]; then
        echo "$comp is not supported" 1>&2
        exit 1
    fi

    echo "=================================================="
    echo "= Setting up $comp...                             "
    echo "=================================================="
    stow $comp
    eval $setup_func
    echo "=================================================="
    echo "= $comp setup done!                               "
    echo "=================================================="
done
