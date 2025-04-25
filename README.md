# Introduction

Manage config files using [stow][1]. The general prodecure to enable
stow-managed application config is:

- clone [dotfiles][3] project
- change directory to `~/dotfiles` or whatever you see fit
- run `stow TOOL_NAME`
- do any extra application-specific setup

Here is the sequence of commands for your reference:

    cd $HOME
    git clone https://github.com/schnell18/dotfiles.git
    cd dotfiles
    stow zsh

Reference: [Using GNU Stow to manage your dotfiles][2].

## Managed tool catalog

- alacritty
- dlv
- ghostty
- git
- jupyter
- latexmk
- lsd
- npm
- nvim
- podman
- tmux
- zathura
- zsh

## Recommended tools
The following softwares are recommended:

- [jq][4]
- [tmux][5]
- [neovim][6]
- [neofetch][7]
- [sdkman][8]
- [nvm][9]
- [gvm][10]
- [luaver][11]
- [docker][12] or [podman][13]
- [lsd][14]

## Extra setup instructions

While running `stow TOOL_NAME` is sufficient for most tools, some tools do
require additional setup. This section details the extra instructions to follow
for such tools.


### tmux
After you stow tmux, you need clone the sub modules of tmux by:

    cd ~/dotfiles/tmux/.config/tmux
    git submodule update

On first launch of tmux, you press `C a I`(Control a Shift i) to install plugins.

### neovim
dotfiles now links to the neovim config managed by nvchad, plugin install occur
on firt time neovim is started.

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
