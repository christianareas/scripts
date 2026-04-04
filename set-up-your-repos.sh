#!/bin/bash

# reminder, to make this script executable:
# chmod +x set-up-your-repos.sh

# ===================
# Clone Repo Function
# ===================

# If a repo doesn’t exist locally, clone it.
clone_repo() {
  # Variables.
  name=$1
  dir="${name##*/}"

  # If the repo exists locally, skip it.
  if [ -d "$dir" ]; then
    echo -e "- $dir already exists locally. Skipping this repo…"

  # Else, clone it.
  else
    echo -e ""
    gh repo clone "$name"
  fi
}

# ===============
# Prompt For Path
# ===============

# Prompt the user for where to clone their repos.
read -p "Where do you want to clone your repos? " path
echo -e ""

# If the path doesn’t exist, use the current directory.
if [ ! -d "$path" ]; then
  echo -e "\nCouldn’t find that directory. Your repos will be cloned in the current directory."
  path="."
fi

# Change to the path.
cd "$path"

# ===========================
# Clone User’s Personal Repos
# ===========================

# Get the user’s GitHub username.
username=$(gh api user --jq .login 2> /dev/null)

# If the user’s not signed in, prompt them to sign in.
if [ $? -ne 0 ]; then
  echo -e "\nYou must sign in to GitHub CLI. Run gh auth login and follow the onscreen instructions."
  exit 1
fi

# Display the user’s GitHub username and prompt them to clone their personal repos.
read -p "You’re signed in to GitHub CLI as $username. Ready to clone your personal repos (y/n)? " answer
case ${answer:0:1} in
  "y" | "Yes" )
    echo -e "\nCloning your personal repos…"
    # Create a directory for the user’s personal repos.
    echo -e "\nCreating $username directory for your personal repos…\n"
    mkdir -p "$username"
    cd "$username"

    for name in $(gh repo list --limit 100 --json nameWithOwner -q '.[].nameWithOwner'); do
      clone_repo "$name"
    done
    cd ..
  ;;
  * )
    echo -e "\nExiting…"
    exit 0
  ;;
esac

echo -e "\nDone!"
