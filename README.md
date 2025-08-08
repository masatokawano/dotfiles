# Masato's Dotfiles

Personal configuration files for macOS development environment.

## Overview

This repository contains my personal dotfiles and configurations for:

- **Zsh** - Shell configuration with Powerlevel10k theme and Sheldon plugin manager
- **Git** - Version control configuration
- **Tmux** - Terminal multiplexer configuration
- **Neovim** - Text editor configuration
- **Various CLI tools** - Additional configurations

## Installation

### Quick Setup

```bash
git clone <repository-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

### Manual Setup

1. Clone this repository:
   ```bash
   git clone <repository-url> ~/dotfiles
   ```

2. Run the installation script:
   ```bash
   cd ~/dotfiles
   chmod +x install.sh
   ./install.sh
   ```

3. Restart your shell:
   ```bash
   exec zsh
   ```

### Options

- `--dry-run`: Preview what would be installed without making changes
- `--help`: Show help information

## Structure

```
dotfiles/
├── .config/
│   ├── sheldon/          # Sheldon plugin manager config
│   ├── alacritty/        # Alacritty terminal config
│   ├── nvim/             # Neovim configuration
│   └── ...
├── zsh/
│   ├── .zshrc            # Zsh configuration
│   ├── .zshenv           # Zsh environment variables
│   └── .p10k.zsh         # Powerlevel10k configuration
├── git/
│   ├── .gitconfig        # Git configuration
│   └── .gitignore_global # Global gitignore
├── tmux/
│   └── .tmux.conf        # Tmux configuration
├── misc/                 # Other dotfiles
├── install.sh            # Installation script
└── README.md             # This file
```

## Key Features

### Zsh Configuration
- **Powerlevel10k** theme with 2-line classic prompt
- **Sheldon** plugin manager for performance
- Enhanced directory navigation with `enhancd`
- Syntax highlighting and autocompletion
- Development environment integration (Python, Node.js, Rust, Go, Haskell)

### Git Configuration
- User information and credentials
- Global gitignore patterns
- Git LFS support
- Sourcetree integration

### Tmux Configuration
- Custom prefix key (Ctrl-f)
- Vim-style key bindings
- Pane synchronization
- Custom status bar with system monitoring
- Plugin management with TPM

## Requirements

- macOS (tested on macOS Sonoma)
- Zsh shell
- Git
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme
- [Sheldon](https://github.com/rossmacarthur/sheldon) plugin manager
- [Tmux](https://github.com/tmux/tmux) terminal multiplexer
- Various development tools (mise, cargo, ghcup, etc.)

## Customization

### Environment Variables

Set the following environment variables in your `.zshrc` or environment:

- `OPENAI_API_KEY` - OpenAI API key (if using AI tools)
- `AWS_REGION` - AWS region for cloud services
- `AWS_PROFILE` - AWS profile for authentication

### Personal Configuration

Before using these dotfiles, update:

1. Git configuration in `git/.gitconfig`:
   - User name and email
   - Credential helpers

2. Zsh configuration in `zsh/.zshrc`:
   - API keys and tokens
   - Personal environment variables

## Backup

The installation script automatically backs up existing dotfiles to `~/.dotfiles-backup` with timestamps.

## Troubleshooting

### Zsh Issues
- Run `p10k configure` to reconfigure Powerlevel10k
- Clear Sheldon cache: `rm -rf ~/.cache/sheldon.zsh`
- Reload configuration: `exec zsh`

### Tmux Issues
- Reload configuration: `Ctrl-f r` (in tmux)
- Install plugins: `Ctrl-f I` (capital i)

### Git Issues
- Update credential helpers in `.gitconfig`
- Check global gitignore path

## License

These dotfiles are personal configurations. Feel free to use and modify as needed.