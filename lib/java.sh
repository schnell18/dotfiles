function __dotfiles_setup_java {
    # Ensure zip and unzip are installed (required by sdkman)
    if ! command -v zip >/dev/null 2>&1; then
        ensure_install zip
    fi
    if ! command -v unzip >/dev/null 2>&1; then
        ensure_install unzip
    fi

    # Install sdkman if not present
    if [[ ! -d $HOME/.sdkman ]]; then
        curl -s "https://get.sdkman.io" | bash
    fi

    # Source sdkman
    source "$HOME/.sdkman/bin/sdkman-init.sh"

    # Check if JDK 17 Azul Zulu is already installed
    if ! sdk list java | grep -q "17.0.13-zulu.*installed"; then
        sdk install java 17.0.13-zulu
    fi

    # Set as default if not already set
    if ! sdk current java | grep -q "17.0.13-zulu"; then
        sdk default java 17.0.13-zulu
    fi

    # Install Maven if not present
    if ! sdk list maven | grep -q "installed"; then
        sdk install maven
    fi

}
