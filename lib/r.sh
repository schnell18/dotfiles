function __dotfiles_setup_r {
    # install R
    case $OS_DISTRO in
        macos)
            ensure_install r
        ;;
        ubuntu)
            ensure_install r-base r-base-dev
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
    Rscript -e 'dir.create(Sys.getenv("R_LIBS_USER"), recursive = TRUE, showWarnings = FALSE); install.packages("languageserver", lib = Sys.getenv("R_LIBS_USER"))'
}


