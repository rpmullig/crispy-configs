#!/bin/bash

# Function to check if a command is available
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Java 17 if not already installed
if ! command_exists javac; then
    if command_exists brew; then
        brew install openjdk@17
    elif command_exists apt; then
        sudo apt update
        sudo apt install -y openjdk-17-jdk
    else
        echo "Neither brew nor apt found. Cannot install Java." >&2
        exit 1
    fi
fi

# Set JAVA_HOME if not already set
if [ -z "$JAVA_HOME" ]; then
    export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))
    export PATH=$PATH:$JAVA_HOME/bin
    echo 'export JAVA_HOME=$JAVA_HOME' >> ~/.bashrc
    echo 'export PATH=$PATH:$JAVA_HOME/bin' >> ~/.bashrc
fi

# Install Go if not already installed
if ! command_exists go; then
    if command_exists brew; then
        brew install go
    elif command_exists apt; then
        sudo apt update
        sudo apt install -y golang-go
    else
        echo "Neither brew nor apt found. Cannot install Go." >&2
        exit 1
    fi
fi

# Set Go environment variables if not already set
if ! grep -q '/lib/go/bin' <<< "$PATH"; then
    export PATH=$PATH:/lib/go/bin
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOPATH/bin
    echo 'export GOPATH=$HOME/go' >> ~/.bashrc
    echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
fi

# Install Rust if not already installed
if ! command_exists rustc; then
    if ! command_exists rustup; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        source $HOME/.cargo/env
    fi
fi

# Set Rust environment variables if not already set
if ! grep -q '/usr/local/cargo/bin' <<< "$PATH"; then
    export PATH=$PATH:/usr/local/cargo/bin
    echo 'export PATH=$PATH:/usr/local/cargo/bin' >> ~/.bashrc
fi

# Install npm if not already installed
if ! command_exists npm; then
    if command_exists brew; then
        brew install npm
    elif command_exists apt; then
        sudo apt update
        sudo apt install -y npm
    else
        echo "Neither brew nor apt found. Cannot install npm." >&2
        exit 1
    fi
fi

# Install Python if not already installed
if ! command_exists python3; then
    if command_exists brew; then
        brew install python@3
        alias python=python3
    elif command_exists apt; then
        sudo apt update
        sudo apt install -y python3
        alias python=python3
    else
        echo "Neither brew nor apt found. Cannot install Python." >&2
        exit 1
    fi
fi

# Install Neovim if not already installed
if ! command_exists nvim; then
        wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim.appimage -O ~/nvim.appimage
        chmod +x ~/nvim.appimage
        mkdir -p /usr/local/bin/nvim
        mv ~/nvim.appimage /usr/local/bin/nvim/nvim.appimage
        alias nvim=/usr/local/bin/nvim/nvim.appimage
        alias vim=nvim
    else
        echo "Cannot install Neovim." >&2
        exit 1
    fi
fi

# Check if Neovim is installed and set up Packer sync and sourcing plugins
if command_exists nvim; then
    # Check if Packer is installed and install it if necessary
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


echo "Moving config files from repo into $HOME folder"

# Check if .bashrc exists in the home directory
if [ -f "$HOME/.bashrc" ]; then
    # Append the tmux startup script to .bashrc
    cat << 'EOF' >> "$HOME/.bashrc"

# Start tmux on shell login if it's not already running
if [ -n "$BASH" ] && [ -z "$TMUX" ] && command -v tmux &> /dev/null; then
    exec tmux
fi
EOF

    # Print a message indicating that the script was added to .bashrc
    echo "tmux startup script added to .bashrc."
else
    # Print a message indicating that .bashrc doesn't exist
    echo "Error: .bashrc file not found in the home directory." >&2
fi

# Check if .zshrc exists in the home directory
if [ -f "$HOME/.zshrc" ]; then
    # Append the tmux startup script to .zshrc
    cat << 'EOF' >> "$HOME/.zshrc"

# Start tmux on shell login if it's not already running
if [ -n "$ZSH" ] && [ -z "$TMUX" ] && command -v tmux &> /dev/null; then
    exec tmux
fi
EOF

    # Print a message indicating that the script was added to .zshrc
    echo "tmux startup script added to .zshrc."
else
    # Print a message indicating that .zshrc doesn't exist
    echo "Error: .zshrc file not found in the home directory." >&2
fi

# Move contents of .config/nvim to $HOME/.config/nvim
if [ -d "./.config/nvim" ]; then
    mkdir -p "$HOME/.config"
    mv -v "./.config/nvim/*" "$HOME/.config/nvim/"
    echo "Contents of .config/nvim moved to $HOME/.config/nvim."
else
    echo "Error: .config/nvim directory not found." >&2
fi

# Move .tmux.conf to $HOME
if [ -f "./.tmux.conf" ]; then
    mv -v "./.tmux.conf" "$HOME/.tmux.conf"
    echo ".tmux.conf moved to $HOME."
else
    echo "Error: .tmux.conf file not found." >&2
fi

# Reload .bashrc to apply changes
source ~/.bashrc

