function __dotfiles_setup_python {
    case $OS_DISTRO in
        macos)
            ensure_install python3
            curl -LsSf https://astral.sh/uv/install.sh | sh
        ;;
        ubuntu)
            ensure_install python3-venv
            curl -LsSf https://astral.sh/uv/install.sh | sh
        ;;
        arch)
            echo "All set"
            curl -LsSf https://astral.sh/uv/install.sh | sh
        ;;
        *)
            echo "Unsupported OS DISTRO: $OS_DISTRO" 1>&2
            exit 1
        ;;
    esac
    uv tool install ruff@latest
}

