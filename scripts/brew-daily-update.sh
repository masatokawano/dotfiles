#!/bin/bash

# Daily Homebrew Update Script
# ============================

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Log file
LOG_FILE="$HOME/.local/share/logs/brew-update.log"
mkdir -p "$(dirname "$LOG_FILE")"

# Function to log with timestamp
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log "Starting daily Homebrew update..."

# Check if Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
    log "ERROR: Homebrew not found"
    exit 1
fi

# Update Homebrew itself
log "Updating Homebrew..."
if brew update >> "$LOG_FILE" 2>&1; then
    log "✅ Homebrew updated successfully"
else
    log "❌ Failed to update Homebrew"
    exit 1
fi

# Upgrade all packages
log "Upgrading packages..."
OUTDATED=$(brew outdated --quiet)

if [ -z "$OUTDATED" ]; then
    log "✅ All packages are up to date"
else
    log "Packages to upgrade: $(echo "$OUTDATED" | tr '\n' ' ')"
    
    if brew upgrade >> "$LOG_FILE" 2>&1; then
        log "✅ Packages upgraded successfully"
    else
        log "❌ Failed to upgrade some packages"
    fi
fi

# Clean up old versions
log "Cleaning up old versions..."
if brew cleanup >> "$LOG_FILE" 2>&1; then
    log "✅ Cleanup completed"
else
    log "❌ Cleanup failed"
fi

# Check for issues
log "Running brew doctor..."
DOCTOR_OUTPUT=$(brew doctor 2>&1)
if [ $? -eq 0 ]; then
    log "✅ No issues found with brew doctor"
else
    log "⚠️ brew doctor found issues:"
    echo "$DOCTOR_OUTPUT" >> "$LOG_FILE"
fi

log "Daily Homebrew update completed"

# Optional: Send notification (requires terminal-notifier)
if command -v terminal-notifier >/dev/null 2>&1; then
    if [ -z "$OUTDATED" ]; then
        terminal-notifier -title "Homebrew" -message "All packages up to date" -sound Glass
    else
        terminal-notifier -title "Homebrew" -message "Packages updated successfully" -sound Glass
    fi
fi