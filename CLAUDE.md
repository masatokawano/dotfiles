# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS development environment configuration. It contains shell configurations, development tool settings, and automation scripts for maintaining a consistent development environment across machines.

## Architecture and Structure

### Core Components

**Installation System:**
- `install.sh` - Main installation script with backup functionality and dry-run mode
- `setup.sh` - Comprehensive auto-setup script that installs dependencies and configures environment
- Symlink-based configuration management with automatic backup to `~/.dotfiles-backup`

**Configuration Categories:**
- **Shell Environment** (`zsh/`) - Zsh configuration with Powerlevel10k theme and Sheldon plugin management
- **Version Control** (`git/`) - Git configuration and global gitignore patterns  
- **Terminal Multiplexer** (`tmux/`) - Tmux configuration with custom key bindings
- **Editors** (`.config/nvim/`, `.config/NvChad/`) - Neovim configurations
- **Development Tools** (`.config/`) - Various CLI tool configurations (sheldon, alacritty, zed, etc.)

**Automation System:**
- **Homebrew Auto-Update** - Daily package management via launchd
- `scripts/brew-daily-update.sh` - Automated brew update/upgrade/cleanup with logging
- `launchd/com.user.brew-daily-update.plist` - System-level scheduling at 8:00 AM daily
- `scripts/setup-brew-auto-update.sh` - Installation script for automation

### Key Technical Features

**Shell Configuration (zsh/):**
- Powerlevel10k theme with 2-line classic prompt
- Sheldon plugin manager with intelligent caching system
- Development environment integration (Python, Node.js, Rust, Go, Haskell via mise/asdf)
- Enhanced utilities: eza (ls replacement), enhancd (cd enhancement)

**Git Integration:**
- Global gitignore patterns for common development artifacts
- Git LFS support and Sourcetree integration
- Credential helper configuration

**Terminal Multiplexer (tmux/):**
- Custom prefix key (Ctrl-f) instead of default Ctrl-b
- Vim-style key bindings and pane management
- System monitoring in status bar
- TPM (Tmux Plugin Manager) integration

## Development Commands

### Installation and Setup
```bash
# Quick installation
./install.sh

# Preview changes without applying
./install.sh --dry-run

# Complete environment setup (installs dependencies)
./setup.sh

# Manual shell reload
exec zsh
```

### Homebrew Automation Management
```bash
# Setup daily auto-update
./scripts/setup-brew-auto-update.sh

# Manual update execution
./scripts/brew-daily-update.sh

# Manage automation
launchctl unload ~/Library/LaunchAgents/com.user.brew-daily-update.plist  # Stop
launchctl load ~/Library/LaunchAgents/com.user.brew-daily-update.plist    # Start

# View update logs
tail -f ~/.local/share/logs/brew-update.log
```

### Configuration Management
```bash
# Reconfigure Powerlevel10k theme
p10k configure

# Clear Sheldon plugin cache
rm -rf ~/.cache/sheldon.zsh && exec zsh

# Reload tmux configuration
# In tmux session: Ctrl-f r
```

## Environment Requirements

### Essential Dependencies
- **macOS** (primary target platform)
- **Xcode Command Line Tools** - Essential development tools (installed via `xcode-select --install`)
- **Homebrew** - Package management
- **Zsh** - Primary shell (usually pre-installed)
- **Git** - Version control (included in Xcode Command Line Tools)

### Development Tools Installed by setup.sh
- **Terminal**: alacritty, zellij
- **Editors**: neovim, zed, neovide  
- **CLI Tools**: sheldon (plugin manager), eza (enhanced ls), mise (environment manager), gh (GitHub CLI)
- **Fonts**: Nerd Font (Meslo LG) for proper icon rendering (installed directly without homebrew/cask-fonts tap)

### Optional Language Environments
- **Rust** - Via rustup (cargo environment)
- **Haskell** - Via GHCup  
- **Node.js/Python** - Via mise or asdf version managers

## Configuration Customization

### Required Personal Setup
Before using these dotfiles, update the following:

1. **Git Configuration** (`git/.gitconfig`):
   - User name and email addresses
   - Credential helper settings

2. **Shell Environment** (`zsh/.zshrc`):
   - API keys (currently commented out):
     - `OPENAI_API_KEY`
     - `ANTHROPIC_MODEL` 
     - `CLAUDE_CODE_USE_BEDROCK`
   - AWS configuration (pre-configured for claude-code profile)

### Security Considerations
- API keys and sensitive tokens are commented out in configuration files
- Automatic backup system preserves existing configurations before modification
- Global gitignore excludes common sensitive file patterns
- `.netrc` and credential files are included but should be reviewed for sensitive information

## Troubleshooting

### Shell Issues
```bash
# Theme not loading
p10k configure

# Plugins not working  
rm -rf ~/.cache/sheldon.zsh
exec zsh

# Development environments not available
mise install && mise use --global node@latest python@latest
```

### Automation Issues
```bash
# Check if brew auto-update is running
launchctl list | grep com.user.brew-daily-update

# View automation logs
ls -la ~/.local/share/logs/
tail -f ~/.local/share/logs/brew-update.log
```

### Permission Issues
```bash
# Fix .config directory permissions
sudo chown -R $(whoami) ~/.config

# Make scripts executable
chmod +x ~/dotfiles/scripts/*.sh
```