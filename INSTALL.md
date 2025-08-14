# Dotfiles Installation Guide

このdotfilesを新しいマシンに適用するためのインストールガイドです。

## 必要なアプリケーション

### 必須アプリケーション

#### ターミナル・シェル
- **zsh** - シェル（通常macOSにプリインストール済み）
- **alacritty** - ターミナルエミュレータ
  ```bash
  brew install --cask alacritty
  ```

#### プロンプト・プラグイン管理
- **powerlevel10k** - zshプロンプトテーマ
  ```bash
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
  ```
- **sheldon** - zshプラグインマネージャ
  ```bash
  brew install sheldon
  ```

#### エディタ・開発環境
- **Neovim** - エディタ
  ```bash
  brew install neovim
  ```
- **Zed** - モダンエディタ
  ```bash
  brew install --cask zed
  ```
- **neovide** - Neovim GUI
  ```bash
  brew install --cask neovide
  ```

#### ターミナルマルチプレクサ
- **zellij** - ターミナルマルチプレクサ
  ```bash
  brew install zellij
  ```

#### 開発環境管理
- **mise** - 開発環境管理ツール
  ```bash
  brew install mise
  ```

#### Git・GitHub
- **git** - バージョン管理（通常プリインストール済み）
- **gh** - GitHub CLI
  ```bash
  brew install gh
  ```

#### ファイル管理・ユーティリティ
- **eza** - 拡張lsコマンド
  ```bash
  brew install eza
  ```

### オプション

#### 言語環境
- **Rust** (Cargo)
  ```bash
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  ```
- **Haskell** (GHCup)
  ```bash
  curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
  ```
- **asdf** - 複数言語バージョン管理
  ```bash
  brew install asdf
  ```

#### 拡張機能
- **github-copilot** - AI コーディング支援
  ```bash
  gh extension install github/gh-copilot
  ```
- **enhancd** - 拡張cdコマンド（sheldon経由でインストール）
- **base16-shell** - カラーテーマ（sheldon経由でインストール）

## インストール手順

### 1. Xcode Command Line Toolsをインストール
```bash
xcode-select --install
```

### 2. Homebrewをインストール
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 3. 必須アプリケーションをインストール
```bash
# ターミナル・エディタ
brew install --cask alacritty
brew install neovim
brew install --cask zed
brew install --cask neovide

# 開発ツール
brew install zellij
brew install mise
brew install gh
brew install sheldon
brew install eza

# プロンプトテーマ
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
```

### 4. dotfilesをクローン・適用
```bash
git clone <your-dotfiles-repo> ~/dotfiles
cd ~/dotfiles
./install.sh
```

### 5. GitHub認証設定
```bash
gh auth login
gh extension install github/gh-copilot
```

### 6. 言語環境セットアップ（必要に応じて）
```bash
# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Haskell
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

# asdf
brew install asdf
```

### 7. シェルをリロード
```bash
exec zsh
```

## 設定の確認

### フォント設定
Neovim/Alacrittyでアイコンを正しく表示するために、Nerd Fontをインストールしてください：
```bash
# homebrew/cask-fontsのtapは不要になりました（2024年5月に統合）
brew install --cask font-meslo-lg-nerd-font
```

### Powerlevel10kの設定
初回起動時に設定ウィザードが表示されます：
```bash
p10k configure
```

## オプション設定

### Homebrew自動更新の設定
毎朝8時にHomebrew を自動更新するように設定できます：

```bash
# launchdを使用した自動更新（推奨）
~/dotfiles/scripts/setup-brew-auto-update.sh

# または、シェル起動時の更新（軽量版）
echo 'source ~/dotfiles/scripts/brew-update-on-shell-start.sh' >> ~/.zshrc
```

**管理コマンド:**
```bash
# 停止
launchctl unload ~/Library/LaunchAgents/com.user.brew-daily-update.plist

# 開始  
launchctl load ~/Library/LaunchAgents/com.user.brew-daily-update.plist

# 手動実行
~/dotfiles/scripts/brew-daily-update.sh

# ログ確認
tail -f ~/.local/share/logs/brew-update.log
```

## トラブルシューティング

### 権限エラー
一部のディレクトリで権限エラーが発生する場合：
```bash
sudo chown -R $(whoami) ~/.config
```

### sheldonキャッシュのクリア
プラグインが正しく読み込まれない場合：
```bash
rm -rf ~/.cache/sheldon.zsh
exec zsh
```

### mise環境の再構築
開発環境が正しく設定されない場合：
```bash
mise install
mise use --global node@latest python@latest
```