#!/bin/sh
# shellcheck disable=SC2088
# dotfiles が正しく適用されているかを確認
#   sh ~/dotfiles/scripts/verify.sh

set -u

fail=0
ok() { printf '  \033[32m✓\033[0m %s\n' "$*"; }
ng() { printf '  \033[31m✗\033[0m %s\n' "$*"; fail=1; }

# 新しいログインシェルでの解決先
resolve() { zsh -lic "command -v $1" 2>/dev/null | tail -n 1; }

check_default() {
  actual=$(defaults read "$1" "$2" 2>/dev/null || echo "(未設定)")
  if [ "$actual" = "$3" ]; then ok "$1 $2 = $3"; else ng "$1 $2 = $actual（期待値 $3）"; fi
}

# --- コマンド ---
echo "コマンド"
for cmd in brew chezmoi mise git gh nvim node npm bun pnpm python3 codex; do
  path=$(resolve "$cmd")
  if [ -n "$path" ]; then ok "$cmd -> $path"; else ng "$cmd が見つからない"; fi
done
# node と python は mise 管理であること
for cmd in node python3; do
  case "$(resolve "$cmd")" in
    "$HOME"/.local/share/mise/*) ok "$cmd は mise 管理" ;;
    *) ng "$cmd が mise 管理ではない" ;;
  esac
done

# --- git ---
echo "git"
email=$(git config --global user.email || true)
case "$email" in
  *@users.noreply.github.com) ok "user.email = $email" ;;
  *) ng "user.email が noreply ではない: $email" ;;
esac
if [ "$(git config --global commit.gpgsign)" = "true" ]; then ok "commit.gpgsign = true"; else ng "commit.gpgsign が無効"; fi
if [ ! -e "$HOME/.gitconfig" ]; then ok "~/.gitconfig なし"; else ng "~/.gitconfig がある"; fi

# --- chezmoi ---
echo "chezmoi"
if chezmoi verify >/dev/null 2>&1; then ok "差分なし"; else ng "差分あり"; chezmoi diff | head -40; fi

# --- macOS ---
echo "macOS"
check_default -g KeyRepeat 2
check_default -g ApplePressAndHoldEnabled 0
check_default com.apple.dock autohide 1
check_default com.apple.finder ShowPathbar 1
check_default com.apple.desktopservices DSDontWriteNetworkStores 1
check_default com.apple.screencapture location "$HOME/Pictures/Screenshots"

# --- ~ 直下 ---
# シェルを一度起動してから、余計なファイルが作られていないか
echo "~ 直下"
zsh -lic 'exit' >/dev/null 2>&1
for f in .zsh_history .zcompdump .zsh_sessions .lesshst; do
  if [ ! -e "$HOME/$f" ]; then ok "~/$f なし"; else ng "~/$f がある"; fi
done

if [ "$fail" -eq 0 ]; then echo "すべて OK"; else echo "失敗あり"; exit 1; fi
