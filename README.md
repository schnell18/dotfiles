# Introduction

Manage config files using [stow][1] by following [Using GNU Stow to manage your
dotfiles][2].
The general prodecure to enable stow-managed application config is:

- clone [dotfiles][3] project
- change directory to `~/dotfiles` or whatever you see fit
- run `stow YOUR_APP`
- do any extra application-specific setup

Here is the sequence of commands for your reference:

    cd $HOME
    git clone https://github.com/schnell18/dotfiles.git
    cd dotfiles
    stow zsh

## neovim
After you stow nvim, you need install plugins required by neovim by:

    nvim -c 'PlugInstall'

This installs a dozen of plugins for you.
You may also install plugin inside neovim for the first time.

[1]: https://www.gnu.org/software/stow/
[2]: http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html
