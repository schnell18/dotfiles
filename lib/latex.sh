function __dotfiles_setup_latex {
    case $OS_DISTRO in
        macos)
            # Install MacTeX via Homebrew cask
            if ! brew list --cask mactex >/dev/null 2>&1; then
                brew install --cask mactex
            fi
        ;;
        ubuntu)
            # Install texlive-full for complete LaTeX environment
            ensure_install \
                texlive-full \
                texlive-latex-extra \
                texlive-fonts-recommended \
                texlive-fonts-extra
        ;;
        arch)
            # Install comprehensive LaTeX support
            ensure_install \
                texlive-latex \
                texlive-xetex \
                texlive-latexextra \
                texlive-latexrecommended \
                texlive-fontsrecommended \
                texlive-fontsextra \
                texlive-bibtexextra
        ;;
        *)
            echo "Unsupported OS DISTRO: $OS_DISTRO" 1>&2
            exit 1
        ;;
    esac
}
