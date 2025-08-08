#!/bin/bash

# Dotfiles installation script
# This script creates symlinks from home directory to dotfiles repository

DOTFILES_DIR="$HOME/dotfiles"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Backup function
backup_file() {
    local file="$1"
    if [[ -e "$file" && ! -L "$file" ]]; then
        local backup_dir="$HOME/.dotfiles-backup"
        mkdir -p "$backup_dir"
        local backup_file="$backup_dir/$(basename "$file").backup.$(date +%Y%m%d_%H%M%S)"
        mv "$file" "$backup_file"
        log_info "Backed up $file to $backup_file"
    fi
}

# Symlink function
create_symlink() {
    local source="$1"
    local target="$2"
    
    # Create target directory if it doesn't exist
    local target_dir=$(dirname "$target")
    if [[ ! -d "$target_dir" ]]; then
        mkdir -p "$target_dir"
        log_info "Created directory $target_dir"
    fi
    
    # Backup existing file/symlink
    backup_file "$target"
    
    # Remove existing symlink or file
    if [[ -L "$target" ]]; then
        rm "$target"
    fi
    
    # Create symlink
    ln -s "$source" "$target"
    
    if [[ -L "$target" ]]; then
        log_info "Created symlink: $target -> $source"
    else
        log_error "Failed to create symlink: $target -> $source"
    fi
}

# Main installation
main() {
    log_info "Installing dotfiles..."
    
    # Check if dotfiles directory exists
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        log_error "Dotfiles directory not found: $DOTFILES_DIR"
        exit 1
    fi
    
    # Zsh configuration
    if [[ -f "$DOTFILES_DIR/zsh/.zshrc" ]]; then
        create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
    fi
    
    if [[ -f "$DOTFILES_DIR/zsh/.zshenv" ]]; then
        create_symlink "$DOTFILES_DIR/zsh/.zshenv" "$HOME/.zshenv"
    fi
    
    if [[ -f "$DOTFILES_DIR/zsh/.p10k.zsh" ]]; then
        create_symlink "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
    fi
    
    # Git configuration
    if [[ -f "$DOTFILES_DIR/git/.gitconfig" ]]; then
        create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
    fi
    
    if [[ -f "$DOTFILES_DIR/git/.gitignore_global" ]]; then
        create_symlink "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"
    fi
    
    # Tmux configuration
    if [[ -f "$DOTFILES_DIR/tmux/.tmux.conf" ]]; then
        create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
    fi
    
    # .config directory files
    if [[ -f "$DOTFILES_DIR/.config/sheldon/plugins.toml" ]]; then
        create_symlink "$DOTFILES_DIR/.config/sheldon/plugins.toml" "$HOME/.config/sheldon/plugins.toml"
    fi
    
    # Miscellaneous files
    for file in "$DOTFILES_DIR/misc"/.??*; do
        if [[ -f "$file" ]]; then
            local filename=$(basename "$file")
            create_symlink "$file" "$HOME/$filename"
        fi
    done
    
    log_info "Dotfiles installation completed!"
    log_warn "Please restart your shell or run 'exec zsh' to apply changes"
}

# Run with --help flag
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help    Show this help message"
    echo "  --dry-run     Show what would be done without making changes"
    echo ""
    echo "This script will:"
    echo "  1. Backup existing dotfiles to ~/.dotfiles-backup"
    echo "  2. Create symlinks from home directory to dotfiles repository"
    echo "  3. Set up shell configuration, git config, and other dotfiles"
    exit 0
fi

# Dry run mode
if [[ "$1" == "--dry-run" ]]; then
    echo "DRY RUN MODE - No changes will be made"
    echo ""
    echo "Would create the following symlinks:"
    
    # Just show what would be done
    [[ -f "$DOTFILES_DIR/zsh/.zshrc" ]] && echo "  $HOME/.zshrc -> $DOTFILES_DIR/zsh/.zshrc"
    [[ -f "$DOTFILES_DIR/zsh/.zshenv" ]] && echo "  $HOME/.zshenv -> $DOTFILES_DIR/zsh/.zshenv"
    [[ -f "$DOTFILES_DIR/zsh/.p10k.zsh" ]] && echo "  $HOME/.p10k.zsh -> $DOTFILES_DIR/zsh/.p10k.zsh"
    [[ -f "$DOTFILES_DIR/git/.gitconfig" ]] && echo "  $HOME/.gitconfig -> $DOTFILES_DIR/git/.gitconfig"
    [[ -f "$DOTFILES_DIR/git/.gitignore_global" ]] && echo "  $HOME/.gitignore_global -> $DOTFILES_DIR/git/.gitignore_global"
    [[ -f "$DOTFILES_DIR/tmux/.tmux.conf" ]] && echo "  $HOME/.tmux.conf -> $DOTFILES_DIR/tmux/.tmux.conf"
    [[ -f "$DOTFILES_DIR/.config/sheldon/plugins.toml" ]] && echo "  $HOME/.config/sheldon/plugins.toml -> $DOTFILES_DIR/.config/sheldon/plugins.toml"
    
    for file in "$DOTFILES_DIR/misc"/.??*; do
        if [[ -f "$file" ]]; then
            local filename=$(basename "$file")
            echo "  $HOME/$filename -> $file"
        fi
    done
    
    exit 0
fi

# Run main function
main