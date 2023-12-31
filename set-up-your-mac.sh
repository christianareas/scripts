#!/bin/bash

# todo:
# - reorganize installs by type (for example, install mysql and tableplus in one step).
# - tell the user what things are about to get installed, and possibly give them a chance to select options.
# - detect what’s already installed and skip those things.
# - write in a different language, such as JavaScript, Rust, or Swift -- or all of the above!

# reminder, to make this script executable:
# chmod +x set-up-your-mac.sh

# ===============
# Prompt Function
# ===============
prompt_and_run () {
  while :
  do
    # prompt
    echo "$1"
    echo -n "y/n(skip): "
    # capture the answer
    read -r answer
    # use the answer to run the commands or skip
    shopt -s nocasematch
    case $answer in
      "y" | "yes" )
        shopt -u nocasematch
        $2
        break
        ;;
      "n" | "no" | "s" | "skip")
        shopt -u nocasematch
        break
        ;;
      *)
        echo "Sorry, I didn’t catch that."
        ;;
    esac
  done
}

# ====================================
# Install Command Line Tools for Xcode
# ====================================
commands () {
  echo "Installing Command Line Tools for Xcode..."
  xcode-select --install
  sudo xcodebuild -license accept
}

prompt_and_run \
  "Do you want to install Command Line Tools for Xcode?" \
  commands

# ================
# Install Homebrew
# ================
commands () {
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  (echo; echo 'eval "$(/usr/local/bin/brew shellenv)"') >> ~/.zprofile
  eval "$(/usr/local/bin/brew shellenv)"
}

prompt_and_run \
  "Do you want to install Homebrew?" \
  commands

# ====================
# Update Homebrew Taps
# ====================
commands () {
  echo "Updating Homebrew taps..."
  brew tap homebrew/cask-versions
  brew tap homebrew/cask-fonts
  brew tap mongodb/brew
  brew tap lencx/chatgpt https://github.com/lencx/ChatGPT.git
}

prompt_and_run \
  "Do you want to update Homebrew taps?" \
  commands

# =====================
# Install App Store CLI
# =====================
commands () {
  echo "Installing the App Store CLI..."
  brew install mas
}

prompt_and_run \
  "Do you want to install the App Store CLI?" \
  commands

# ======================
# Install App Store Apps
# ======================
# 1440147259  AdGuard for Safari
# 640199958   Apple Developer
# 937984704   Amphetamine
# 608834326   Calendars
# 1055511498  Day One
# 1482920575  DuckDuckGo Privacy Essentials
# 424389933   Final Cut Pro
# 682658836   GarageBand
# 1460836908  GoPro Player + ReelSteady
# 775737590   iA Writer
# 408981434   iMovie
# 409183694   Keynote
# 462058435   Microsoft Excel
# 462054704   Microsoft Word
# 1592917505  Noir - Dark Mode for Safari
# 409203825   Numbers
# 1474884867  Orchid
# 409201541   Pages
# 967805235   Paste
# 803453959   Slack
# 1153157709  Speedtest
# 1496833156  Swift Playgrounds
# 1225570693  Ulysses
# 1284863847  Unsplashed Wallpapers
# 1147396723  WhatsApp
# 497799835   Xcode
commands () {
  echo "Installing App Store apps..."
  mas install \
    1440147259 \
    640199958 \
    937984704 \
    608834326 \
    409183694 \
    409203825 \
    409201541 \
    1055511498 \
    1482920575 \
    424389933 \
    682658836 \
    1460836908 \
    775737590 \
    408981434 \
    462058435 \
    462054704 \
    1474884867 \
    967805235 \
    803453959 \
    1153157709 \
    1496833156 \
    1225570693 \
    1284863847 \
    1147396723
    # 497799835
}

prompt_and_run \
  "Do you want to install App Store apps?" \
  commands

# ==================================
# Install Homebrew CLI and Cask Apps
# ==================================
commands () {
  echo "Installing Homebrew CLI and cask apps..."
  brew install \
    helix \
    kind \
    kubectl
  brew install --cask \
    anaconda \
    appcleaner \
    balenaetcher \
    brave-browser \
    discord \
    docker \
    elgato-control-center \
    elgato-stream-deck \
    firefox \
    google-chrome \
    itsycal \
    karabiner-elements \
    microsoft-edge \
    microsoft-teams \
    mongodb-compass \
    obsidian \
    postman \
    qmk-toolbox \
    readdle-spark \
    rectangle \
    responsively \
    scrivener \
    stoplight-studio \
    tableplus \
    unity-hub \
    via \
    visual-studio \
    visual-studio-code \
    warp \
    webex \
    zoom
  brew install --cask \
    chatgpt --no-quarantine
}

prompt_and_run \
  "Do you want to install Homebrew CLI and cask apps?" \
  commands

# ==================================
# Download Safari Technology Preview
# ==================================
commands () {
  echo "Downloading Safari Technology Preview..."
  # download Safari Technology Preview
  open https://developer.apple.com/safari/resources/  
}

prompt_and_run \
  "Do you want to download Safari Technology Preview?" \
  commands

# ==================================
# Download and Install Logitech Apps
# ==================================
commands () {
  echo "Downloading and installing Logitech apps..."
  brew install wget
  # download and open Logi Options+ installer
  wget -P ~/Downloads https://download01.logi.com/web/ftp/pub/techsupport/optionsplus/logioptionsplus_installer.zip
  open ~/Downloads/logioptionsplus_installer.app
  # download and open Logi Tune installer
  wget -P ~/Downloads https://software.vc.logitech.com/downloads/tune/LogiTuneInstaller.dmg
  open ~/Downloads/LogiTuneInstaller.dmg
}

prompt_and_run \
  "Do you want to download and install Logitech apps?" \
  commands

# =============
# Install Fonts
# =============
commands () {
  echo "Installing fonts..."
  brew install --cask \
    font-sf-pro \
    font-sf-compact \
    font-sf-mono \
    font-sf-arabic \
    font-new-york \
    font-ia-writer-duo \
    font-ia-writer-duospace \
    font-ia-writer-mono \
    font-ia-writer-quattro
}

prompt_and_run \
  "Do you want to install fonts?" \
  commands

# =============
# Configure git
# =============
commands () {
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
  commands

# ==================
# Install GitHub CLI
# ==================
commands () {
  echo "Installing GitHub CLI..."
  brew install gh
  gh auth login
  gh extension install github/gh-copilot --force
}

prompt_and_run \
  "Do you want to install GitHub CLI?" \
  commands

# ===========
# Install FNM
# ===========
commands () {
  echo "Installing FNM..."
  curl -fsSL https://fnm.vercel.app/install | bash
}

prompt_and_run \
  "Do you want to install FNM?" \
  commands

# =============
# Install MySQL
# =============
commands () {
  brew install mysql
}

prompt_and_run \
  "Do you want to install MySQL?" \
  commands

# ==================
# Install PostgreSQL
# ==================
commands () {
  brew install postgresql@15
  brew services start postgresql@15
}

prompt_and_run \
  "Do you want to install PostgreSQL?" \
  commands


# ===============
# Install MongoDB
# ===============
commands () {
  brew install mongodb-community
  brew services start mongodb-community
}

prompt_and_run \
  "Do you want to install MongoDB?" \
  commands

# ===============
# Configure macOS
# ===============
commands () {
  echo "Configuring macOS..."
  # configure dock
  defaults write com.apple.dock "autohide" -bool "true"
  defaults write com.apple.dock "autohide-delay" -float "0.25"
  defaults write com.apple.dock "autohide-time-modifier" -float "0.25"
  defaults write com.apple.dock "largesize" -int "175"
  defaults write com.apple.dock "mineffect" -string "scale"
  defaults write com.apple.dock "tilesize" -int "64"
  # configure finder
  defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
  defaults write com.apple.finder "AppleShowAllFiles" -bool "true"
  defaults write com.apple.finder "ShowStatusBar" -bool true
  # configure menu bar
  defaults write com.apple.menuextra.clock "FlashDateSeparators" -bool "true"
  defaults write com.apple.menuextra.clock "DateFormat" -string "\"h:mm:ss a\""
  # configure mission control
  defaults write com.apple.dock "mru-spaces" -bool "false"
  # restart dock and finder
  killall Dock Finder SystemUIServer
  # todo: add all the things!
  # - trackpad and mouse settings
  # - keyboard settings
}

# ========
# Menu Bar
# ========
# Amphetamine (Coffee Carafe)
# Day One
# Elgato Control Center
# Elgato Stream Deck
# Logi Tune
# Paste
# Speedtest
# Unsplash Wallpapers
# Wi-Fi
# Sound
# Bluetooth
# Battery (if applicable)
# Focus
# Itsycal
# Control Center
# Clock

# ====
# Dock
# ====
# Finder
# Spark
# Calendars
# Reminders
# Day One
# Messages
# FaceTime
# Discord
# Slack
# Safari
# Safari Technology Preview
# Podcasts
# News
# Music
# TV
# iA Writer
# Obsidian
# Scrivener
# System Settings
# Warp
# Visual Studio Code
# Stoplight Studio
# Xcode
# Swift Playgrounds

prompt_and_run \
  "Do you want to configure macOS?" \
  commands

# ===
# Fin
# ===
echo "*Fin*"

# Todo: Add something to set up and source .zshrc.
# # fnm
# export PATH="/Users/christian/Library/Application Support/fnm:$PATH"
# eval "`fnm env`"

# # conda
# export PATH="/opt/homebrew/anaconda3/bin:$PATH"
