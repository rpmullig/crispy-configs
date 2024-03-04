# crispy-configs
Configs for setting up my terminal and neovim editor.

# Run Instructions
```
sudo ./environmentSetup.sh
```

The above run instruction will install `java 17`, `go`, `python3`, `rust`
as well installing neovim and moving `./confi/nvim/*` to the $HOME dir
and then install plugins. It also moves the .tmux.conf to $HOME dir
and adds it to the .bashrc or .zshrc.

This was an attempt to work on both Linux using apt and MacOs using Homebrew.

# Prerequisite 
With the TMUX config, if you're experiencnig errors with fonts in the status bar, install nerd fonts https://github.com/ryanoasis/nerd-fonts

install ripgrep https://github.com/BurntSushi/ripgrep

# Purpose
The ideal is to do a cold setup of this so that the environment is ready quickly.


## Credit
As listed, a lot of the neovim plugins were obtianed from "ThePrimeagen" from his
repo here: https://github.com/ThePrimeagen/init.lua

Tmux config borrowed from Deams of code: https://github.com/dreamsofcode-io/tmux


