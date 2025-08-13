#!/bin/bash

# Setup script for Homebrew daily auto-update
# ===========================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

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

DOTFILES_DIR="$HOME/dotfiles"
PLIST_FILE="com.user.brew-daily-update.plist"
LAUNCHD_DIR="$HOME/Library/LaunchAgents"

log_info "Setting up Homebrew daily auto-update..."

# Create necessary directories
mkdir -p "$HOME/.local/share/logs"
mkdir -p "$LAUNCHD_DIR"

# Copy plist file to LaunchAgents
if [ -f "$DOTFILES_DIR/launchd/$PLIST_FILE" ]; then
    cp "$DOTFILES_DIR/launchd/$PLIST_FILE" "$LAUNCHD_DIR/"
    log_success "Copied plist file to LaunchAgents"
else
    log_error "Plist file not found: $DOTFILES_DIR/launchd/$PLIST_FILE"
    exit 1
fi

# Load the launch agent
launchctl load "$LAUNCHD_DIR/$PLIST_FILE"
log_success "Loaded launch agent"

# Verify it's loaded
if launchctl list | grep -q "com.user.brew-daily-update"; then
    log_success "Launch agent is active"
else
    log_warning "Launch agent may not be properly loaded"
fi

# Install terminal-notifier for notifications (optional)
if ! command -v terminal-notifier >/dev/null 2>&1; then
    log_info "Installing terminal-notifier for desktop notifications..."
    brew install terminal-notifier
fi

echo
log_success "Setup complete!"
echo
log_info "Configuration:"
echo "  • Daily update time: 8:00 AM"
echo "  • Logs location: ~/.local/share/logs/"
echo "  • Script location: $DOTFILES_DIR/scripts/brew-daily-update.sh"
echo
log_info "Management commands:"
echo "  • Stop:  launchctl unload ~/Library/LaunchAgents/$PLIST_FILE"
echo "  • Start: launchctl load ~/Library/LaunchAgents/$PLIST_FILE"
echo "  • Test:  $DOTFILES_DIR/scripts/brew-daily-update.sh"
echo "  • View logs: tail -f ~/.local/share/logs/brew-update.log"