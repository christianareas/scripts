#!/bin/bash

# --------------------------------------------------------------------------------

# Reminder, to make this script executable:
# chmod +x set-up-your-mac.sh

# --------------------------------------------------------------------------------

# Exit on errors (-e), unset variables (-u), and pipe failures (-o pipefail).
set -euo pipefail

# --------------------------------------------------------------------------------
# Prompt.
# --------------------------------------------------------------------------------
prompt_and_run() {
  while :; do
    echo
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
# See what's installed.
# --------------------------------------------------------------------------------
command_exists() {
  command -v "$1" &>/dev/null
}

xcode_cli_installed() {
  xcode-select -p &>/dev/null
}

rosetta_installed() {
  [[ "$(uname -m)" != "arm64" ]] || arch -arch x86_64 /usr/bin/true 2>/dev/null
}

all_formulas_installed() {
  for formula in "$@"; do
    if ! echo "$INSTALLED_FORMULAS" | grep -qx "$formula"; then
      return 1
    fi
  done
  return 0
}

all_casks_installed() {
  for cask in "$@"; do
    if ! echo "$INSTALLED_CASKS" | grep -qx "$cask"; then
      return 1
    fi
  done
  return 0
}

all_mas_installed() {
  for app_id in "$@"; do
    if ! echo "$INSTALLED_MAS" | grep -qx "$app_id"; then
      return 1
    fi
  done
  return 0
}

prompt_and_run_if_needed() {
  local prompt_text="$1"
  local run_fn="$2"
  shift 2

  local all_installed=true
  for check in "$@"; do
    if ! eval "$check"; then
      all_installed=false
      break
    fi
  done

  if $all_installed; then
    echo
    echo "$prompt_text"
    echo "(Already installed. Skipping...)"
    return
  fi

  prompt_and_run "$prompt_text" "$run_fn"
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

prompt_and_run_if_needed \
  "Do you want to install Xcode Command Line Tools?" \
  install_xcode_cli_tools \
  'xcode_cli_installed'

# Install Rosetta.
install_rosetta() {
  echo "Installing Rosetta..."
  sudo softwareupdate --install-rosetta
}

prompt_and_run_if_needed \
  "Do you want to install Rosetta?" \
  install_rosetta \
  'rosetta_installed'

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

prompt_and_run_if_needed \
  "Do you want to install Homebrew?" \
  install_homebrew \
  'command_exists brew'

# Install App Store CLI.
install_app_store_cli() {
  echo "Installing the App Store CLI..."
  brew install mas
}

prompt_and_run_if_needed \
  "Do you want to install the App Store CLI?" \
  install_app_store_cli \
  'command_exists mas'

# --------------------------------------------------------------------------------
# Installed.
# --------------------------------------------------------------------------------

# Installed.
INSTALLED_FORMULAS=$(brew list --formula 2>/dev/null || true)
INSTALLED_CASKS=$(brew list --cask 2>/dev/null || true)
INSTALLED_MAS=$(mas list 2>/dev/null | awk '{print $1}' || true)

# Upgrade installed.
upgrade_packages() {
  echo "Upgrading installed packages..."
  brew upgrade
  mas upgrade
}

prompt_and_run \
  "Do you want to upgrade installed packages?" \
  upgrade_packages

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

prompt_and_run_if_needed \
  "Do you want to install communications apps?" \
  install_communications_apps \
  'all_casks_installed discord fantastical readdle-spark slack webex whatsapp zoom'

# --------------------------------------------------------------------------------
# Browsers.
# --------------------------------------------------------------------------------

# Install browsers.
install_browsers() {
  echo "Installing browsers..."
  # 1440147259  AdGuard for Safari
  mas install \
    1440147259
  brew install --cask \
    brave-browser \
    google-chrome \
    safari-technology-preview \
    zen \
    zen@twilight
}

prompt_and_run_if_needed \
  "Do you want to install browsers?" \
  install_browsers \
  'all_mas_installed 1440147259' \
  'all_casks_installed brave-browser google-chrome safari-technology-preview zen zen@twilight'

# Install AI browsers.
install_ai_browsers() {
  echo "Installing AI browsers..."
  brew install --cask \
    chatgpt-atlas \
    comet
}

prompt_and_run_if_needed \
  "Do you want to install AI browsers?" \
  install_ai_browsers \
  'all_casks_installed chatgpt-atlas comet'

# --------------------------------------------------------------------------------
# Writing.
# --------------------------------------------------------------------------------

# Install writing apps.
install_writing_apps() {
  echo "Installing writing apps..."
  # 1055511498  Day One
  # 775737590   iA Writer
  mas install \
    1055511498 \
    775737590
  brew install --cask \
    notion \
    obsidian \
    scrivener
}

prompt_and_run_if_needed \
  "Do you want to install writing apps?" \
  install_writing_apps \
  'all_mas_installed 1055511498 775737590' \
  'all_casks_installed notion obsidian scrivener'

# --------------------------------------------------------------------------------
# Creativity and entertainment.
# --------------------------------------------------------------------------------

# Install creativity and entertainment apps.
install_creativity_entertainment_apps() {
  echo "Installing creativity and entertainment apps..."
  # 450527929  djay Pro
  # 682658836  GarageBand
  # 408981434  iMovie
  mas install \
    450527929 \
    682658836 \
    408981434
  brew install --cask \
    steam
}

prompt_and_run_if_needed \
  "Do you want to install creativity and entertainment apps?" \
  install_creativity_entertainment_apps \
  'all_mas_installed 450527929 682658836 408981434' \
  'all_casks_installed steam'

# --------------------------------------------------------------------------------
# Productivity and utilities.
# --------------------------------------------------------------------------------

# Install productivity and utility apps.
install_productivity_utility_apps() {
  echo "Installing productivity and utility apps..."
  # 937984704   Amphetamine
  # 361285480   Keynote
  # 462058435   Microsoft Excel
  # 462054704   Microsoft Word
  # 361304891   Numbers
  # 361309726   Pages
  # 967805235   Paste
  # 1153157709  Speedtest
  # 490179405   Okta Verify
  # 1284863847  Unsplash Wallpapers
  mas install \
    937984704 \
    361285480 \
    462058435 \
    462054704 \
    361304891 \
    361309726 \
    967805235 \
    1153157709 \
    490179405 \
    1284863847
  brew install --cask \
    1password \
    appcleaner \
    balenaetcher \
    google-drive \
    protonvpn \
    rectangle \
    transmission
}

prompt_and_run_if_needed \
  "Do you want to install productivity and utility apps?" \
  install_productivity_utility_apps \
  'all_mas_installed 937984704 409183694 462058435 462054704 409203825 409201541 967805235 1153157709 490179405 1284863847' \
  'all_casks_installed 1password appcleaner balenaetcher google-drive protonvpn rectangle transmission'

# --------------------------------------------------------------------------------
# AI tools.
# --------------------------------------------------------------------------------

# Install AI tools.
install_ai_tools() {
  echo "Installing AI tools..."
  brew install --cask \
    chatgpt \
    claude \
    codex-app \
    ollama-app
}

prompt_and_run_if_needed \
  "Do you want to install AI tools?" \
  install_ai_tools \
  'all_casks_installed chatgpt claude codex-app ollama-app'


# Install AI CLI tools.
install_ai_cli_tools() {
  echo "Installing AI CLI tools..."
  brew install --cask \
    claude-code \
    codex
}

prompt_and_run_if_needed \
  "Do you want to install AI CLI tools?" \
  install_ai_cli_tools \
  'all_casks_installed claude-code codex'

# --------------------------------------------------------------------------------
# Developer tools.
# --------------------------------------------------------------------------------

# Install developer tools.
install_developer_tools() {
  echo "Installing developer tools..."
  # 640199958   Apple Developer
  # 1496833156  Swift Playgrounds
  # 497799835   Xcode
  mas install \
    640199958 \
    1496833156 \
    497799835
  brew install --cask \
    cursor \
    docker-desktop \
    figma \
    github \
    postman \
    tableplus \
    unity-hub \
    visual-studio \
    visual-studio-code \
    warp \
    warp@preview \
    xcodes-app
}

prompt_and_run_if_needed \
  "Do you want to install developer tools?" \
  install_developer_tools \
  'all_mas_installed 640199958 1496833156 497799835' \
  'all_casks_installed cursor docker-desktop figma github postman tableplus unity-hub visual-studio visual-studio-code warp warp@preview xcodes-app'


# Install CLI tools.
install_cli_tools() {
  echo "Installing CLI tools..."
  brew install \
    imagemagick \
    kind \
    kubectl \
    mkcert \
    postman-cli \
    shfmt \
    slack-cli \
    uv \
    vercel-cli \
    wget \
    xcodes
}

prompt_and_run_if_needed \
  "Do you want to install CLI tools?" \
  install_cli_tools \
  'all_formulas_installed imagemagick kind kubernetes-cli mkcert shfmt uv vercel-cli wget xcodes' \
  'all_casks_installed postman-cli slack-cli'

# --------------------------------------------------------------------------------
# Peripheral apps.
# --------------------------------------------------------------------------------

# Install peripheral apps.
install_peripheral_apps() {
  echo "Installing peripheral apps..."
  brew install --cask \
    elgato-control-center \
    elgato-stream-deck \
    karabiner-elements \
    logi-options-plus \
    qmk-toolbox \
    via \
    vial
}

prompt_and_run_if_needed \
  "Do you want to install peripheral apps?" \
  install_peripheral_apps \
  'all_casks_installed elgato-control-center elgato-stream-deck karabiner-elements logi-options-plus qmk-toolbox via vial'

# Download and install Logi Tune.
install_logi_tune() {
  echo "Downloading and installing Logi Tune..."
  # Download and open Logi Tune installer.
  wget -P ~/Downloads https://software.vc.logitech.com/downloads/tune/LogiTuneInstaller.dmg
  open ~/Downloads/LogiTuneInstaller.dmg
}

prompt_and_run \
  "Do you want to download and install Logi Tune?" \
  install_logi_tune

# Download AM Master.
download_am_master() {
  echo "Downloading AM Master..."
  # Download AM Master installer.
  open https://www.angrymiao.com/en/am-master/
}

prompt_and_run \
  "Do you want to download and install AM Master?" \
  download_am_master

# --------------------------------------------------------------------------------
# Git and GitHub CLI.
# --------------------------------------------------------------------------------

# Configure Git.
configure_git() {
  echo "Configuring git..."
  # Configure the default branch name.
  git config --global init.defaultBranch main
  git config --global user.name "Christian Areas"
  git config --global user.email me@areas.me
  # List Git configurations.
  git config -l
}

prompt_and_run \
  "Do you want to configure git?" \
  configure_git

# Install and configure GitHub CLI.
install_github_cli() {
  echo "Installing GitHub CLI..."
  brew install gh
  gh auth login
}

prompt_and_run_if_needed \
  "Do you want to install and configure GitHub CLI?" \
  install_github_cli \
  'all_formulas_installed gh'

# --------------------------------------------------------------------------------
# FNM.
# --------------------------------------------------------------------------------

# Install FNM.
install_fnm() {
  echo "Installing FNM..."
  curl -fsSL https://fnm.vercel.app/install | bash
}

prompt_and_run_if_needed \
  "Do you want to install FNM?" \
  install_fnm \
  'all_formulas_installed fnm'

# Update Node.
update_node() {
  echo "Updating Node..."
  eval "$(fnm env)"
  fnm install 24
  fnm install 25
  fnm default 25
  fnm ls
}

prompt_and_run \
  "Do you want to update Node?" \
  update_node

# --------------------------------------------------------------------------------
# Fonts.
# --------------------------------------------------------------------------------

# Install fonts.
install_fonts() {
  echo "Installing fonts..."
  brew install --cask \
    font-ia-writer-duo \
    font-ia-writer-mono \
    font-ia-writer-quattro \
    font-new-york \
    font-sf-arabic \
    font-sf-compact \
    font-sf-mono \
    font-sf-pro
}

prompt_and_run_if_needed \
  "Do you want to install fonts?" \
  install_fonts \
  'all_casks_installed font-ia-writer-duo font-ia-writer-mono font-ia-writer-quattro font-new-york font-sf-arabic font-sf-compact font-sf-mono font-sf-pro'

# --------------------------------------------------------------------------------
# Dock.
# --------------------------------------------------------------------------------

# Install dockutil.
install_dockutil() {
  echo "Installing dockutil..."
  brew install dockutil
}

prompt_and_run_if_needed \
  "Do you want to install dockutil?" \
  install_dockutil \
  'all_formulas_installed dockutil'

# Set up Dock.
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
  dockutil --add "/Applications/Podcasts.app" --no-restart
  dockutil --add "/Applications/News.app" --no-restart
  dockutil --add "/Applications/Music.app" --no-restart
  dockutil --add "/Applications/iA Writer.app" --no-restart
  dockutil --add "/Applications/Scrivener.app" --no-restart
  dockutil --add "/Applications/System Settings.app" --no-restart
  dockutil --add "/Applications/Claude.app" --no-restart
  dockutil --add "/Applications/Warp.app" --no-restart
  dockutil --add "/Applications/WarpPreview.app" --no-restart
  dockutil --add "/Applications/GitHub Desktop.app" --no-restart
  dockutil --add "$HOME/Applications/GitHub.app" --no-restart
  dockutil --add "/Applications/Cursor.app" --no-restart
  dockutil --add "/Applications/TablePlus.app" --no-restart
  dockutil --add "$HOME/Applications/Drizzle Studio.app" --no-restart
  dockutil --add "/Applications/Postman.app" --no-restart
  dockutil --add "$HOME/Applications/Vercel Dashboard.app" --no-restart
  dockutil --add "$HOME/Applications/Neon Console.app" --no-restart
  dockutil --add "$HOME/Applications/Stripe Dashboard.app" --no-restart
  dockutil --add "$HOME/Applications/areas.me.app" --no-restart
  dockutil --add "$HOME/Applications/areas.me | Local.app" --no-restart
  dockutil --add "$HOME/Applications/CIMI.app" --no-restart
  dockutil --add "$HOME/Applications/CounterLedger.app" --no-restart
  dockutil --add "/Applications" --view grid --display stack --sort name --section others --no-restart
  dockutil --add "$HOME/Downloads" --view grid --display stack --section others --no-restart
  killall Dock
}

prompt_and_run \
  "Do you want to set up Dock?" \
  setup_dock

# --------------------------------------------------------------------------------
# macOS.
# --------------------------------------------------------------------------------

# Configure macOS.
configure_macos() {
  echo "Configuring macOS..."
  # Configure Dock.
  defaults write com.apple.dock "autohide" -bool "true"
  defaults write com.apple.dock "autohide-delay" -float "0.25"
  defaults write com.apple.dock "autohide-time-modifier" -float "0.25"
  defaults write com.apple.dock "magnification" -bool "true"
  defaults write com.apple.dock "largesize" -int "175"
  defaults write com.apple.dock "mineffect" -string "scale"
  defaults write com.apple.dock "tilesize" -int "64"
  # Configure Finder.
  defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
  defaults write com.apple.finder "AppleShowAllFiles" -bool "true"
  defaults write com.apple.finder "ShowStatusBar" -bool "true"
  # Configure Menu Bar.
  defaults write com.apple.menuextra.clock "FlashDateSeparators" -bool "true"
  defaults write com.apple.menuextra.clock "DateFormat" -string "\"h:mm:ss a\""
  # Configure Mission Control.
  defaults write com.apple.dock "mru-spaces" -bool "false"
  # Configure keyboard.
  defaults write NSGlobalDomain "KeyRepeat" -int "2"
  defaults write NSGlobalDomain "InitialKeyRepeat" -int "15"
  # Configure trackpad.
  defaults write com.apple.AppleMultitouchTrackpad "Clicking" -bool "true"
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad "Clicking" -bool "true"
  defaults write com.apple.AppleMultitouchTrackpad "FirstClickThreshold" -int "2"
  defaults write com.apple.AppleMultitouchTrackpad "SecondClickThreshold" -int "2"
  defaults write NSGlobalDomain "com.apple.trackpad.scaling" -float "3"
  # Configure mouse.
  defaults write NSGlobalDomain "com.apple.mouse.scaling" -float "3"
  defaults write com.apple.AppleMultitouchMouse "MouseButtonMode" -string "TwoButton"
  defaults write com.apple.driver.AppleBluetoothMultitouch.mouse "MouseButtonMode" -string "TwoButton"
  # Restart Dock and Finder.
  killall Dock Finder SystemUIServer
}

prompt_and_run \
  "Do you want to configure macOS?" \
  configure_macos

# --------------------------------------------------------------------------------
# Menu Bar.
# --------------------------------------------------------------------------------
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

# --------------------------------------------------------------------------------
# Fin.
# --------------------------------------------------------------------------------

echo
echo "*Fin*"

# --------------------------------------------------------------------------------
