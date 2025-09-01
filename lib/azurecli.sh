function __dotfiles_setup_azurecli {
    case $OS_DISTRO in
        ubuntu)
            if [ ! -f /etc/apt/sources.list.d/azure-cli.sources ]; then
                curl -sLS https://packages.microsoft.com/keys/microsoft.asc |
                    gpg --dearmor | sudo tee /usr/share/keyrings/microsoft.gpg > /dev/null
                sudo chmod go+r /usr/share/keyrings/microsoft.gpg

                # install azure-cli apt repo
                cat<<EOF | sudo tee /etc/apt/sources.list.d/azure-cli.sources
"Types: deb
URIs: https://packages.microsoft.com/repos/azure-cli/
Suites: $(lsb_release -cs)
Components: main
Architectures: $(dpkg --print-architecture)
Signed-by: /usr/share/keyrings/microsoft.gpg"
EOF

            fi
            ensure_install azure-cli
        ;;
        macos)
            ensure_install azure-cli
        ;;
        *)
            echo "Unsupported OS DISTRO: $OS_DISTRO" 1>&2
            exit 1
        ;;
    esac

}
