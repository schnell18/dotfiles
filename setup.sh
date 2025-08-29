#!/bin/bash

# fail fast
set -eo pipefail

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
                    sudo apt-get update && sudo apt-get install -y "$PKG"
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

function usage {
    cat <<EOF
Headless development tool installation and configuration utility.
Crafted by Justin Zhang <schnell18@gmail.com>
Usage:
    ./setup.sh -lhc

    -h: show usage of this tool
    -l: list supported components
    -c: install and configure relevant components
EOF
}

function list {
    setup_funcs=$(declare -f | grep "^__dotfiles_setup_" | cut -d' ' -f1)
    for func in $setup_funcs; do
        comp=${func#__dotfiles_setup_}
        echo $comp
    done
}

function setup {
    comps="$*"

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
        if ! command -v brew >/dev/null 2>&1; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
    fi

    if ! command -v stow >/dev/null 2>&1; then
        ensure_install stow
    fi
    # setup_funcs=$(grep -e "^function" $0 | cut -d' ' -f2)
    setup_funcs=$(declare -f | grep "^__dotfiles_setup_" | cut -d' ' -f1)
    # Ensure node is installed
    if [[ ! -d $HOME/.nvm ]]; then
        [[ ! $comps =~ "*node*" ]] && comps="node $comps"
    fi
    for comp in $comps; do
        # validate the component specified by user is supported
        setup_func="__dotfiles_setup_$(echo $comp | tr '[:upper:]' '[:lower:]')"
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
}

source lib/ansible.sh
source lib/ghostty.sh
source lib/git.sh
source lib/golang.sh
source lib/java.sh
source lib/latex.sh
source lib/lua.sh
source lib/node.sh
source lib/nvim.sh
source lib/podman.sh
source lib/libvirt.sh
source lib/python.sh
source lib/r.sh
source lib/rust.sh
source lib/tmux.sh
source lib/vagrant.sh
source lib/kubectl.sh
source lib/helm.sh

[[ -z $DEBUG_SETUP ]] || set -x

OPTSTRING=":lhc:"

while getopts ${OPTSTRING} opt; do
    case ${opt} in
        l)
            list
            exit 0
            ;;
        c)
            setup ${OPTARG}
            exit 0
            ;;
        h)
            usage
            exit 0
            ;;
        \?)
            echo "Invalid option: -${OPTARG}."
            usage
            exit 1
            ;;
        :)
            echo "Component is mandatory, use -l to find supported components!" 1>&2
            exit 2
            ;;
    esac
done

usage
