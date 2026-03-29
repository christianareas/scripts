#!/bin/bash

# Exit on errors (-e), unset variables (-u), and pipe failures (-o pipefail).
set -euo pipefail

# Todo:
# - reorganize installs by type (for example, install mysql and TablePlus in one step).
# - tell the user what things are about to get installed, and possibly give them a chance to select options.
# - detect what’s already installed and skip those things.
# - add Add to Dock... web apps. For example, GitHub.
# - write in a different language, such as TypeScript, Rust, or Swift -- or all of the above!

# Reminder, to make this script executable:
# chmod +x set-up-your-mac.sh

# --------------------------------------------------------------------------------
# Prompt function.
# --------------------------------------------------------------------------------
prompt_and_run() {
  while :; do
    # Prompt.
    echo "$1"
    echo -n "y/n(skip): "
    # Capture the answer.
    read -r answer
    # Use the answer to run the commands or skip.
    shopt -s nocasematch
    case $answer in
    "y" | "yes")
      "$2"
      break
      ;;
    "n" | "no" | "s" | "skip")
      break
      ;;
    *)
      echo "Sorry, I didn’t catch that."
      continue
      ;;
    esac
    shopt -u nocasematch
  done
}

# --------------------------------------------------------------------------------
# Prerequisites.
# --------------------------------------------------------------------------------

# Install Xcode Command Line Tools.
install_xcode_cli_tools() {
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  sudo xcodebuild -license accept
}

prompt_and_run \
  "Do you want to install Xcode Command Line Tools?" \
  install_xcode_cli_tools

# Install Rosetta.
install_rosetta() {
  echo "Installing Rosetta..."
  sudo softwareupdate --install-rosetta
}

prompt_and_run \
  "Do you want to install Rosetta?" \
  install_rosetta

# Install Homebrew.
install_homebrew() {
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Configure Apple Silicon Mac.
  if [[ "$(uname -m)" == "arm64" ]]; then
    (
      echo
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
    ) >>~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  # Configure Intel Mac.
  else
    (
      echo
      echo 'eval "$(/usr/local/bin/brew shellenv)"'
    ) >>~/.zprofile
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

prompt_and_run \
  "Do you want to install Homebrew?" \
  install_homebrew

# Install App Store CLI.
install_app_store_cli() {
  echo "Installing the App Store CLI..."
  brew install mas
}

prompt_and_run \
  "Do you want to install the App Store CLI?" \
  install_app_store_cli

# --------------------------------------------------------------------------------
# Communications.
# --------------------------------------------------------------------------------

# Install communications apps.
install_communications_apps() {
  echo "Installing communications apps..."
  brew install --cask \
    discord \
    fantastical \
    readdle-spark \
    slack \
    webex \
    whatsapp \
    zoom
}

prompt_and_run \
  "Do you want to install communications apps?" \
  install_communications_apps

# --------------------------------------------------------------------------------
# Browsers.
# --------------------------------------------------------------------------------

# Install browsers.
install_browsers() {
  echo "Installing browsers..."
  brew install --cask \
    brave-browser \
    google-chrome \
    safari-technology-preview \
    zen-browser \
    zen@twilight
}

prompt_and_run \
  "Do you want to install browsers?" \
  install_browsers

# Install AI browsers.
install_ai_browsers() {
  echo "Installing AI browsers..."
  brew install --cask \
    chatgpt-atlas \
    comet
}

prompt_and_run \
  "Do you want to install AI browsers?" \
  install_ai_browsers

# ======================
# Install App Store Apps
# ======================

# 640199958   Apple Developer
# 937984704   Amphetamine
# 1055511498  Day One
# 424389933   Final Cut Pro
# 682658836   GarageBand
# 775737590   iA Writer
# 408981434   iMovie
# 409183694   Keynote
# 462058435   Microsoft Excel
# 462054704   Microsoft Word
# 409203825   Numbers
# 490179405   Okta Verify
# 409201541   Pages
# 967805235   Paste
# 1153157709  Speedtest
# 1496833156  Swift Playgrounds
# 1284863847  Unsplashed Wallpapers
# 497799835   Xcode
install_app_store_apps() {
  echo "Installing App Store apps..."
  mas install \
    1440147259 \
    640199958 \
    937984704 \
    1055511498 \
    424389933 \
    682658836 \
    775737590 \
    408981434 \
    409183694 \
    462058435 \
    462054704 \
    409203825 \
    490179405 \
    409201541 \
    967805235 \
    1153157709 \
    1496833156 \
    1284863847 \
    497799835
}

prompt_and_run \
  "Do you want to install App Store apps?" \
  install_app_store_apps

# ==================================
# Install Homebrew CLI and Cask Apps
# ==================================
install_homebrew_apps() {
  echo "Installing Homebrew CLI and cask apps..."
  brew install \
    dockutil \
    imagemagick \
    kind \
    kubectl \
    mkcert \
    shfmt \
    uv \
    vercel-cli \
    wget
  brew install --cask \
    1password \
    appcleaner \
    balenaetcher \
    chatgpt \
    claude \
    claude-code \
    codex \
    cursor \
    docker \
    elgato-control-center \
    elgato-stream-deck \
    figma \
    github \
    google-drive \
    karabiner-elements \
    logi-options-plus \
    notion \
    obsidian \
    ollama \
    postman \
    postman-cli \
    protonvpn \
    qmk-toolbox \
    rectangle \
    scrivener \
    slack-cli \
    steam \
    tableplus \
    transmission \
    unity-hub \
    via \
    vial \
    visual-studio \
    visual-studio-code \
    warp \
    warp@preview \
    xcodes
}

prompt_and_run \
  "Do you want to install Homebrew CLI and cask apps?" \
  install_homebrew_apps

# ==============================
# Download and Install Logi Tune
# ==============================
install_logi_tune() {
  echo "Downloading and installing Logi Tune..."
  # download and open Logi Tune installer
  wget -P ~/Downloads https://software.vc.logitech.com/downloads/tune/LogiTuneInstaller.dmg
  open ~/Downloads/LogiTuneInstaller.dmg
}

prompt_and_run \
  "Do you want to download and install Logi Tune?" \
  install_logi_tune

# ==============================
# Download AM Master
# ==============================
download_am_master() {
  echo "Downloading AM Master..."
  # download AM Master installer
  open https://www.angrymiao.com/en/am-master/
}

prompt_and_run \
  "Do you want to download and install AM Master?" \
  download_am_master

# =============
# Configure git
# =============
configure_git() {
  echo "Configuring git..."
  # configure the default branch name
  git config --global init.defaultBranch main
  git config --global user.name "Christian Areas"
  git config --global user.email me@areas.me
  # list git configurations
  git config -l
}

prompt_and_run \
  "Do you want to configure git?" \
  configure_git

# ==================
# Install GitHub CLI
# ==================
install_github_cli() {
  echo "Installing GitHub CLI..."
  brew install gh
  gh auth login
}

prompt_and_run \
  "Do you want to install GitHub CLI?" \
  install_github_cli

# ===============================
# Add symlink to iCloud Downloads
# ===============================
add_icloud_downloads_symlink() {
  echo "Adding symlink to iCloud Downloads..."
  ln -s ~/Library/Mobile\ Documents/com~apple~CloudDocs/Downloads ~/Downloads/iCloud\ Downloads
}

prompt_and_run \
  "Do you want to add a symlink to iCloud Downloads?" \
  add_icloud_downloads_symlink

# ===========
# Install FNM
# ===========
install_fnm() {
  echo "Installing FNM..."
  curl -fsSL https://fnm.vercel.app/install | bash
}

prompt_and_run \
  "Do you want to install FNM?" \
  install_fnm

# ========================
# Update and Configure FNM
# ========================
configure_fnm() {
  echo "Updating and configuring FNM..."
  source ~/.zshrc
  fnm install 24
  fnm install 25
  fnm default 25
  fnm ls
}

prompt_and_run \
  "Do you want to update and configure FNM?" \
  configure_fnm

# =============
# Install Fonts
# =============
install_fonts() {
  echo "Installing fonts..."
  brew install --cask \
    font-ia-writer-duo \
    font-ia-writer-duospace \
    font-ia-writer-mono \
    font-ia-writer-quattro \
    font-new-york \
    font-sf-arabic \
    font-sf-compact \
    font-sf-mono \
    font-sf-pro
}

prompt_and_run \
  "Do you want to install fonts?" \
  install_fonts

# ===========
# Set up Dock
# ===========
setup_dock() {
  echo "Setting up Dock..."
  dockutil --remove all --no-restart
  dockutil --add "/Applications/Messages.app" --no-restart
  dockutil --add "/Applications/FaceTime.app" --no-restart
  dockutil --add "/Applications/Spark Desktop.app" --no-restart
  dockutil --add "/Applications/Fantastical.app" --no-restart
  dockutil --add "/Applications/Reminders.app" --no-restart
  dockutil --add "/Applications/Day One.app" --no-restart
  dockutil --add "/Applications/Discord.app" --no-restart
  dockutil --add "/Applications/Slack.app" --no-restart
  dockutil --add "/Applications/Safari.app" --no-restart
  dockutil --add "/Applications/Safari Technology Preview.app" --no-restart
  dockutil --add "/Applications/Zen.app" --no-restart
  dockutil --add "/Applications/Podcasts.app" --no-restart
  dockutil --add "/Applications/News.app" --no-restart
  dockutil --add "/Applications/Music.app" --no-restart
  dockutil --add "/Applications/iA Writer.app" --no-restart
  dockutil --add "/Applications/Pages.app" --no-restart
  dockutil --add "/Applications/Scrivener.app" --no-restart
  dockutil --add "/Applications/System Settings.app" --no-restart
  dockutil --add "/Applications/ChatGPT.app" --no-restart
  dockutil --add "/Applications/Claude.app" --no-restart
  dockutil --add "/Applications/Warp.app" --no-restart
  dockutil --add "/Applications/WarpPreview.app" --no-restart
  dockutil --add "/Applications/GitHub Desktop.app" --no-restart
  dockutil --add "$HOME/Applications/GitHub.app" --no-restart
  dockutil --add "/Applications/Visual Studio Code.app" --no-restart
  dockutil --add "/Applications/Cursor.app" --no-restart
  dockutil --add "/Applications/TablePlus.app" --no-restart
  dockutil --add "/Applications/Postman.app" --no-restart
  dockutil --add "$HOME/Applications/Vercel Dashboard.app" --no-restart
  dockutil --add "$HOME/Applications/Stripe Dashboard.app" --no-restart
  dockutil --add "/Applications" --view grid --display stack --section others --no-restart
  dockutil --add "$HOME/Downloads" --view grid --display stack --section others --no-restart
  killall Dock
}

prompt_and_run \
  "Do you want to set up Dock?" \
  setup_dock

# ===============
# Configure macOS
# ===============
configure_macos() {
  echo "Configuring macOS..."
  # configure dock
  defaults write com.apple.dock "autohide" -bool "true"
  defaults write com.apple.dock "autohide-delay" -float "0.25"
  defaults write com.apple.dock "autohide-time-modifier" -float "0.25"
  defaults write com.apple.dock "magnification" -bool "true"
  defaults write com.apple.dock "largesize" -int "175"
  defaults write com.apple.dock "mineffect" -string "scale"
  defaults write com.apple.dock "tilesize" -int "64"
  # configure finder
  defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
  defaults write com.apple.finder "AppleShowAllFiles" -bool "true"
  defaults write com.apple.finder "ShowStatusBar" -bool "true"
  # configure menu bar
  defaults write com.apple.menuextra.clock "FlashDateSeparators" -bool "true"
  defaults write com.apple.menuextra.clock "DateFormat" -string "\"h:mm:ss a\""
  # configure mission control
  defaults write com.apple.dock "mru-spaces" -bool "false"
  # restart dock and finder
  killall Dock Finder SystemUIServer
  # todo: add all the things!
  # - track pad and mouse settings
  # - keyboard settings
}

prompt_and_run \
  "Do you want to configure macOS?" \
  configure_macos

# ========
# Menu Bar
# ========
# Amphetamine (Coffee Carafe)
# Day One
# Elgato Control Center
# Elgato Stream Deck
# Logi Tune
# Paste
# Rectangle
# Speedtest
# Unsplash Wallpapers
# Wi-Fi
# Sound
# Bluetooth
# Battery (if applicable)
# Focus
# Fast User Switching (if applicable)
# Spark
# Fantastical
# Control Center
# Clock

# ===
# Fin
# ===
echo "*Fin*"
