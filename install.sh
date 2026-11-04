#!/bin/sh
# dotfiles のインストール（何度実行しても安全）
#   curl -fsSL https://raw.githubusercontent.com/solclarus/dotfiles/main/install.sh | sh

set -eu

REPO="${DOTFILES_REPO:-solclarus/dotfiles}"
BRANCH="${DOTFILES_BRANCH:-main}"
SOURCE_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
die() { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

[ "$(uname -s)" = "Darwin" ] || die "macOS 専用です"
[ "$(uname -m)" = "arm64" ] || die "Apple Silicon 専用です"

# --- Homebrew ---
# Xcode Command Line Tools もここで入る
if [ ! -x /opt/homebrew/bin/brew ]; then
  log "Homebrew をインストール"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# --- chezmoi と mise ---
for formula in chezmoi mise; do
  if ! command -v "$formula" >/dev/null 2>&1; then
    log "$formula をインストール"
    brew install "$formula"
  fi
done

# --- dotfiles ---
# 適用時に mise install、brew bundle、macOS の設定も実行される
if [ -d "$SOURCE_DIR/.git" ]; then
  log "dotfiles を更新: $SOURCE_DIR"
  chezmoi update --source "$SOURCE_DIR" --apply
else
  log "dotfiles を clone: $REPO ($BRANCH) -> $SOURCE_DIR"
  chezmoi init --apply --source "$SOURCE_DIR" --branch "$BRANCH" "https://github.com/$REPO.git"
fi

log "完了。新しいターミナルを開いてください"
cat <<'EOF'

初回のみ手作業:
  1. 1Password にサインインし、設定 → 開発者 →「SSH エージェントを使用」をオン
  2. gh auth login
  3. App Store にサインインして、もう一度このスクリプトを実行
EOF
