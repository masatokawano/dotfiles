#!/bin/bash

# Dotfiles Auto Setup Script
# =========================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    log_error "This script is designed for macOS only"
    exit 1
fi

log_info "Starting dotfiles setup..."

# 1. Install Xcode Command Line Tools if not present
if ! xcode-select -p >/dev/null 2>&1; then
    log_info "Installing Xcode Command Line Tools..."
    xcode-select --install
    
    # Wait for installation to complete
    log_info "Waiting for Xcode Command Line Tools installation to complete..."
    until xcode-select -p >/dev/null 2>&1; do
        sleep 5
    done
    log_success "Xcode Command Line Tools installed"
else
    log_success "Xcode Command Line Tools already installed"
fi

# 2. Install Homebrew if not present
if ! command_exists brew; then
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    log_success "Homebrew already installed"
fi

# Update Homebrew
log_info "Updating Homebrew..."
brew update

# 3. Install essential applications
log_info "Installing essential applications..."

# Terminal and editors
brew install --cask alacritty || log_warning "Failed to install alacritty"
brew install neovim || log_warning "Failed to install neovim"
brew install --cask zed || log_warning "Failed to install zed"
brew install --cask neovide || log_warning "Failed to install neovide"

# Development tools
brew install zellij || log_warning "Failed to install zellij"
brew install mise || log_warning "Failed to install mise"
brew install gh || log_warning "Failed to install gh"
brew install sheldon || log_warning "Failed to install sheldon"
brew install eza || log_warning "Failed to install eza"

# Fonts for better terminal experience (no longer need to tap homebrew/cask-fonts)
brew install --cask font-meslo-lg-nerd-font || log_warning "Failed to install Nerd Font"

log_success "Essential applications installed"

# 4. Install Powerlevel10k
if [ ! -d ~/powerlevel10k ]; then
    log_info "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    log_success "Powerlevel10k installed"
else
    log_success "Powerlevel10k already installed"
fi

# 5. Backup existing config files
log_info "Backing up existing configuration files..."
backup_dir="$HOME/.config/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"

# List of files/directories to backup
config_items=(.zshrc .gitconfig .p10k.zsh)
config_dirs=(.config/alacritty .config/gh .config/git .config/github-copilot .config/mise .config/neovide .config/NvChad .config/nvim .config/zed .config/zellij .config/sheldon)

for item in "${config_items[@]}"; do
    if [ -e "$HOME/$item" ] && [ ! -L "$HOME/$item" ]; then
        mv "$HOME/$item" "$backup_dir/"
        log_info "Backed up $item"
    fi
done

for dir in "${config_dirs[@]}"; do
    if [ -e "$HOME/$dir" ] && [ ! -L "$HOME/$dir" ]; then
        mkdir -p "$backup_dir/$(dirname $dir)"
        mv "$HOME/$dir" "$backup_dir/$dir"
        log_info "Backed up $dir"
    fi
done

# 6. Create symbolic links
log_info "Creating symbolic links..."

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Create .config directory if it doesn't exist
mkdir -p ~/.config

# Link config directories
for dir in alacritty gh git github-copilot mise neovide NvChad nvim zed zellij sheldon; do
    if [ -d "$DOTFILES_DIR/.config/$dir" ]; then
        ln -sf "$DOTFILES_DIR/.config/$dir" ~/.config/
        log_success "Linked .config/$dir"
    fi
done

# Link dotfiles
dotfiles=(zsh/zshrc:zshrc git/gitconfig:gitconfig)

for mapping in "${dotfiles[@]}"; do
    src="${mapping%:*}"
    dest="${mapping#*:}"
    
    if [ -f "$DOTFILES_DIR/$src" ]; then
        ln -sf "$DOTFILES_DIR/$src" ~/."$dest"
        log_success "Linked $src to .$dest"
    fi
done

# Link .p10k.zsh if it exists
if [ -f "$DOTFILES_DIR/zsh/p10k.zsh" ]; then
    ln -sf "$DOTFILES_DIR/zsh/p10k.zsh" ~/.p10k.zsh
    log_success "Linked p10k.zsh"
fi

# 7. Install optional tools
read -p "Install Rust (rustup)? [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_info "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source ~/.cargo/env
    log_success "Rust installed"
fi

read -p "Install Haskell (GHCup)? [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_info "Installing Haskell..."
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
    log_success "Haskell installed"
fi

read -p "Install asdf version manager? [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_info "Installing asdf..."
    brew install asdf
    log_success "asdf installed"
fi

# 8. Set up GitHub CLI
if command_exists gh; then
    log_info "Setting up GitHub CLI..."
    echo "Please run 'gh auth login' after setup completes"
    
    read -p "Install GitHub Copilot CLI extension? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        gh extension install github/gh-copilot || log_warning "Failed to install GitHub Copilot extension"
    fi
fi

# 9. Final steps
log_success "Setup complete!"
echo
log_info "Next steps:"
echo "1. Run 'exec zsh' to reload your shell"
echo "2. Run 'p10k configure' to configure Powerlevel10k"
echo "3. Run 'gh auth login' to authenticate with GitHub"
echo "4. Configure your applications as needed"
echo
log_info "Backup of your old configuration files: $backup_dir"
echo "Happy coding! 🚀"