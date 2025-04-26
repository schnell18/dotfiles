setup_alias ()
{
  local al=$1
  local cmd=$2
  $(command -v $cmd >/dev/null 2>&1)
  if [ $? -eq 0 ]; then
    alias $al=$cmd
  fi
}

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/go/bin:/usr/local/bin:$PATH

# load sensitive settings from ~/.config/zsh/.szshrc
if [ -f ~/.config/zsh/.szshrc ]; then
  source ~/.config/zsh/.szshrc
fi

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git python )

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8
export LANG=zh_CN.UTF-8

setup_alias ls lsd
setup_alias vi nvim
setup_alias tf terraform
setup_alias k kubectl

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles

# neovim + zathura
export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET"

# virtualization settings
# export LIBVIRT_DEFAULT_URI=qemu:///session
# export VAGRANT_DEFAULT_PROVIDER=libvirt

# gvm setup
if [ -d $HOME/.gvm ]; then
  export PATH="$HOME/.gvm/bin:$PATH"
  [[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
fi

# nvm setup
if [ -d $HOME/.nvm ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# sdkman setup
if [ -d $HOME/.sdkman ]; then
  export SDKMAN_DIR="$HOME/.sdkman"
  [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
  export HOMEBREW_BOTTLE_DOMAIN=''
  export JAVA_HOME=$HOME/.sdkman/candidates/java/current
fi


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/justin/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/justin/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/justin/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/justin/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
