#!/bin/bash

# Alternative: Update Homebrew on shell start (once per day)
# ==========================================================
# Add this to your .zshrc to run brew update once per day on first shell startup

BREW_UPDATE_FILE="$HOME/.cache/brew-last-update"

# Create cache directory if it doesn't exist
mkdir -p "$(dirname "$BREW_UPDATE_FILE")"

# Check if we've already updated today
if [ -f "$BREW_UPDATE_FILE" ]; then
    LAST_UPDATE=$(cat "$BREW_UPDATE_FILE")
    TODAY=$(date +%Y-%m-%d)
    
    if [ "$LAST_UPDATE" = "$TODAY" ]; then
        # Already updated today, skip
        return 0 2>/dev/null || exit 0
    fi
fi

# Run update in background to not slow down shell startup
(
    echo "🍺 Updating Homebrew in background..."
    
    # Update Homebrew
    if brew update >/dev/null 2>&1; then
        # Check for outdated packages
        OUTDATED=$(brew outdated --quiet 2>/dev/null)
        
        if [ -n "$OUTDATED" ]; then
            echo "📦 Packages available for upgrade: $(echo "$OUTDATED" | wc -l | tr -d ' ')"
            echo "   Run 'brew upgrade' to update them"
        else
            echo "✅ All Homebrew packages are up to date"
        fi
    else
        echo "❌ Failed to update Homebrew"
    fi
    
    # Mark as updated today
    echo "$(date +%Y-%m-%d)" > "$BREW_UPDATE_FILE"
) &

# Don't wait for background process
disown