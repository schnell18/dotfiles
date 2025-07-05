function __dotfiles_setup_r {
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


