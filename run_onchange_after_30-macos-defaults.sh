#!/bin/sh
# macOS の設定（このファイルが変わったときだけ実行）

set -eu

# --- 外観 ---
# ダークモード
defaults write -g AppleInterfaceStyle -string "Dark"
# 拡張子を常に表示
defaults write -g AppleShowAllExtensions -bool true

# --- キーボード ---
# リピート開始までの時間
defaults write -g InitialKeyRepeat -int 15
# リピートの速さ
defaults write -g KeyRepeat -int 2
# 長押しでアクセント入力ではなくキーリピート
defaults write -g ApplePressAndHoldEnabled -bool false
# スペルの自動修正をしない
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
# 引用符を自動で変換しない
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
# ダッシュを自動で変換しない
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false

# --- トラックパッド・マウス ---
# カーソルの速さ
defaults write -g com.apple.trackpad.scaling -float 3
# スクロールの速さ
defaults write -g com.apple.scrollwheel.scaling -float 1
# タップでクリック
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1

# --- Dock ---
# 自動で隠す
defaults write com.apple.dock autohide -bool true
# 表示までの待ち時間なし
defaults write com.apple.dock autohide-delay -float 0
# 最近使ったアプリを表示しない
defaults write com.apple.dock show-recents -bool false
# アイコンの大きさ
defaults write com.apple.dock tilesize -int 36
# 画面下に配置
defaults write com.apple.dock orientation -string "bottom"
# 操作スペースを使用状況で並べ替えない
defaults write com.apple.dock mru-spaces -bool false

# --- Finder ---
# リスト表示
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# 新規ウィンドウはホームを開く
defaults write com.apple.finder NewWindowTarget -string "PfHm"
# パスバーを表示
defaults write com.apple.finder ShowPathbar -bool true
# ステータスバーを表示
defaults write com.apple.finder ShowStatusBar -bool true
# フォルダを先頭に並べる
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# 拡張子変更時の警告を出さない
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# 検索は現在のフォルダから
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# ネットワークドライブと USB に .DS_Store を作らない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# --- スクリーンショット ---
# 保存先
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
# ウィンドウの影を付けない
defaults write com.apple.screencapture disable-shadow -bool true

# --- 反映 ---
for app in Dock Finder SystemUIServer; do
  killall "$app" >/dev/null 2>&1 || true
done
echo "キーボードとトラックパッドの設定はログアウト後に反映されます"
