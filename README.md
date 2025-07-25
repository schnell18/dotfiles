# Introduction

This project automates common development tools installation and configuration
under MacOS and Linux (currently only Ubuntu and Arch are supported) by
leveraging [stow][1]. The general procedure to enable stow-managed tools is:

- clone [dotfiles][3] project
- change directory to `~/dotfiles` or whatever you see fit
- run `./setup.sh` with appropriate options

Here is the sequence of commands for your reference:

    cd $HOME
    git clone https://github.com/schnell18/dotfiles.git
    cd dotfiles
    ./setup.sh -c zsh

## Usage

The `setup.sh` script supports the following command line options:

- `-h`: Show usage information
- `-l`: List all supported components
- `-c COMPONENT`: Install and configure the specified component

### Examples

To show help:

    ./setup.sh -h

To list all supported components:

    ./setup.sh -l

To setup a single component:

    ./setup.sh -c zsh

To setup multiple components (space-separated):

    ./setup.sh -c "golang git lua tmux nvim"

# Manual Setup

The `setup.sh` has automated all the tasks described in this section. Avoid
manual setup using instructions in this section unless the `setup.sh` script
doesn't work.

## Recommended tools
The following software is recommended:

- [jq][4]
- [tmux][5]
- [neovim][6]
- [sdkman][8]
- [nvm][9]
- [gvm][10]
- [luaver][11]
- [docker][12] or [podman][13]
- [lsd][14]

## Extra setup instructions

While running `stow TOOL_NAME` is sufficient for most tools, some tools do
require additional setup. This section details the extra instructions to follow
for such tools on MacOS. Adapt the commands to your own OS distribution.

    # misc tools setup
    # 1. install jq lsd ripgrep curl
    # 2. powerlevel10k setup

    # zsh setup
    # 1. oh-my-zsh setup
    # 2. powerlevel10k setup

    # tmux setup
    # 1. install tmux
    # 2. configure tmux

    # python setup
    # 1. install uv

    # golang setup
    # 1. install gvm

    # neovim setup
    # 1. install neovim
    # 2. enable neovim config

    # localenv setup
    # 1. install podman
    # 2. install localenv


### tmux
After you stow tmux, you need clone the sub modules of tmux by:

    cd ~/dotfiles/
    git submodule init
    git submodule update

On first launch of tmux, you press `C a I`(Control a Shift i) to install plugins.
Or if it doesn't work, you install the required tmux plugins manually as follows:

    cd ~/dotfiles/tmux/.config/tmux
    git submodule init
    git submodule update

Then relaunch tmux to let the plugins take effect.


### neovim

dotfiles now links to the neovim config managed by nvchad, plugin install occur
on first time neovim is started.

### Python w/ uv

On macOS and Linux type this command to install uv, which is a lightning fast
package manager for Python:

    curl -LsSf https://astral.sh/uv/install.sh | sh

# Reference
Reference: [Using GNU Stow to manage your dotfiles][2].

[1]: https://www.gnu.org/software/stow/
[2]: http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html
[3]: https://github.com/schnell18/dotfiles.git
[4]: https://stedolan.github.io/jq/
[5]: https://github.com/tmux/tmux/wiki
[6]: https://neovim.io/
[7]: https://github.com/dylanaraps/neofetch
[8]: https://sdkman.io/
[9]: https://github.com/nvm-sh/nvm
[10]: https://github.com/moovweb/gvm
[11]: https://github.com/DhavalKapil/luaver
[12]: https://www.docker.com/
[13]: https://podman.io/
[14]: https://github.com/lsd-rs/lsd
