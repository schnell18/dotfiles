#!/bin/bash

# --- Configuration ---
CARGO_BIN="$HOME/.cargo/bin"
TOOLS=("cargo-edit" "cargo-audit" "cargo-watch" "cargo-outdated")
RUST_ANALYZER_URL="https://api.github.com/repos/rust-lang/rust-analyzer/releases/latest"
RA_BIN_PATH="$CARGO_BIN/rust-analyzer"

# --- Functions ---
install_rustup() {
  if ! command -v rustup &>/dev/null; then
    echo "Installing rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    export PATH="$HOME/.cargo/bin:$PATH"
  else
    echo "rustup already installed."
  fi
}

install_rust_toolchain() {
  echo "Installing Rust stable toolchain..."
  rustup install stable
  rustup default stable
  rustup component add clippy rustfmt
}

install_cargo_tools() {
  for tool in "${TOOLS[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
      echo "Installing $tool..."
      cargo install "$tool"
    else
      echo "$tool already installed."
    fi
  done
}

install_rust_analyzer() {
  if [[ -x "$RA_BIN_PATH" ]]; then
    echo "rust-analyzer already installed at $RA_BIN_PATH."
    return
  fi

  echo "Installing rust-analyzer..."
  tmpdir=$(mktemp -d)
  curl -s "$RUST_ANALYZER_URL" |
    grep "browser_download_url" |
    grep "$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m)" |
    cut -d '"' -f 4 |
    xargs curl -L -o "$tmpdir/rust-analyzer"

  chmod +x "$tmpdir/rust-analyzer"
  mv "$tmpdir/rust-analyzer" "$RA_BIN_PATH"
  echo "rust-analyzer installed at $RA_BIN_PATH"
}

ensure_path_in_profile() {
  if ! grep -q 'export PATH="$HOME/.cargo/bin:$PATH"' "$HOME/.bashrc" 2>/dev/null; then
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >>"$HOME/.bashrc"
    echo "Added Rust to PATH in ~/.bashrc"
  fi
  if ! grep -q 'export PATH="$HOME/.cargo/bin:$PATH"' "$HOME/.zshrc" 2>/dev/null; then
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >>"$HOME/.zshrc"
    echo "Added Rust to PATH in ~/.zshrc"
  fi
}

# --- Execution ---
# install_rustup

function __dotfiles_setup_rust {
    case $OS_DISTRO in
        macos)
            install_rustup
        ;;
        ubuntu)
            install_rustup
        ;;
        arch)
            install_rustup
        ;;
        *)
            echo "Unsupported OS DISTRO: $OS_DISTRO" 1>&2
            exit 1
        ;;
    esac

    install_rust_toolchain
    install_cargo_tools
    install_rust_analyzer
    ensure_path_in_profile

}
