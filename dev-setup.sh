#!/bin/bash

function check_python_pkg {
    python -c "import $1" >/dev/null 2>&1
}

# fail fast by exiting on first error
set -e

# Install uv and create a project-scoped venv with pre-commit installed
export PATH="$HOME/.local/bin:$PATH"
if ! command -v uv >/dev/null 2>&1; then
    # On macOS and Linux.
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

if [[ ! -d .venv ]]; then
    uv venv --python=3.11
fi

source .venv/bin/activate
if ! check_python_pkg pre_commit ; then
    uv pip install pre-commit
fi

pre-commit install
