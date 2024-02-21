!/bin/bash

# Function to check if a command is available
command_exists() {
    command -v "$1" >/dev/null 2>&1
}


# Install Java 17 if not already install -yed
if ! command_exists javac; then
    sudo apt update
    sudo apt install -y openjdk-17-jdk
fi

# Set JAVA_HOME if not already set
if [ -z "$JAVA_HOME" ]; then
    export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))
    export PATH=$PATH:$JAVA_HOME/bin
fi

# Install Go if not already install -yed
if ! command_exists go; then
    sudo apt update
    sudo apt install -y golang-go
fi

# Set Go environment variables if not already set
if ! grep -q '/lib/go/bin' <<< "$PATH"; then
    export PATH=$PATH:/lib/go/bin
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOPATH/bin
fi

# Install Rust if not already install -yed
if ! command_exists rustc; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source $HOME/.cargo/env
fi

# Set Rust environment variables if not already set
if ! grep -q '/usr/local/cargo/bin' <<< "$PATH"; then
    export PATH=$PATH:/usr/local/cargo/bin
fi

# Install npm if not already install -yed
if ! command_exists npm; then
    sudo apt update
    sudo apt install -y npm
fi

# Install Python if not already install -yed
if ! command_exists python3; then
    sudo apt update
    sudo apt install -y python3
    alias python=python3
fi

# Install Neovim if not already install -yed
if ! command_exists nvim; then
    wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim.appimage -O ~/nvim.appimage
    chmod +x ~/nvim.appimage
    mkdir -p /usr/local/bin/nvim
    mv ~/nvim.appimage /usr/local/bin/nvim/nvim.appimage
    alias nvim=/usr/local/bin/nvim/nvim.appimage
    alias vim=nvim
fi

# Check if Neovim is install -yed and set up Packer sync and sourcing plugins
if command_exists nvim; then
    # Check if Packer is install -yed and install -y it if necessary
    if ! command_exists packer; then
        git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    fi

    # Add Packer sync to init.vim if not already present
    if ! grep -q "packer_sync" ~/.config/nvim/init.vim; then
        echo "call packer#sync()" >> ~/.config/nvim/init.vim
    fi

    # Source all plugins in ~/.config/nvim/after/plugin/ directory
    for file in ~/.config/nvim/after/plugin/*; do
        [ -r "$file" ] && [ -f "$file" ] && source "$file"
    done
fi

# Print success message
echo "Environment setup completed!"

