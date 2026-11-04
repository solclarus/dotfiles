# dotfiles

[![test](https://github.com/solclarus/dotfiles/actions/workflows/test.yml/badge.svg)](https://github.com/solclarus/dotfiles/actions/workflows/test.yml)

macOS (Apple Silicon) 用。chezmoi + mise + Homebrew。

## インストール

```sh
curl -fsSL https://raw.githubusercontent.com/solclarus/dotfiles/main/install.sh | sh
```

その後:

1. 1Password にサインインし、設定 → 開発者 →「SSH エージェントを使用」をオン
2. `gh auth login`
3. App Store にサインインして、もう一度 `install.sh` を実行

## 使い方

```sh
chezmoi edit ~/.config/zsh/.zshrc   # 編集
chezmoi apply           # 反映
chezmoi update          # pull して反映
sh ~/dotfiles/scripts/verify.sh   # 検証
```
