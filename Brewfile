# Homebrew でインストールするもの

# --- CLI ---
brew "git"
brew "gh"
brew "chezmoi"
brew "mise"
brew "neovim"
brew "tree"
brew "gcc"
brew "swift-format"
brew "xcodegen"
brew "mas"

# CI ではサインインできず時間もかかるので入れない
unless ENV["CI"]
  # --- アプリ ---
  # 既存アプリは App Management の保護で adopt できないので、無いときだけ入れる
  cask "1password" unless File.exist?("/Applications/1Password.app")
  cask "1password-cli"
  cask "google-drive"
  cask "warp"
  cask "wezterm"

  # --- Mac App Store ---
  mas "Slack", id: 803453959
  mas "Xcode", id: 497799835
  mas "RunCat Neo", id: 6757801838
end
