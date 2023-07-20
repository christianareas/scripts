#!/bin/bash

# reminder, to make this script executable:
# chmod +x set-up-your-repos.sh

# ===================
# Clone Repo Function
# ===================

# If a repo doesn’t exist locally, clone it.
clone_repo() {
  # Variables.
  url=$1
  name=$(basename "$url" .git)

  # If the repo exists locally, skip it.
  if [ -d "$name" ]; then
    echo -e "$name already exists locally. Skipping this repo…"
  
  # Else, clone it.
  else
    echo -e ""
    git clone "$url"
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
    echo -e "\nCreating $username directory for your personal repos…"
    mkdir -p "$username"
    cd "$username"

    for url in $(gh repo list --json sshUrl,name -q '.[] | .sshUrl'); do
      clone_repo "$url"
    done
    cd ..
  ;;
  * )
    echo -e "\nExiting…"
    exit 0
  ;;
esac

# ======================
# Clone User’s Org Repos
# ======================

# List the user’s orgs.
echo -e "\nSearching for your orgs…"
orgs=$(gh org list | awk '{print $1}' | tail -n +4)

# If the user isn’t part of any orgs, exit.
if [ -z "$orgs" ]; then
  echo -e "\nYou’re not part of any orgs. Exiting…"
  exit 0
fi

# Display the user’s orgs and prompt them to clone their org repos.
echo -e "\nYou’re part of the following orgs:"
echo -e "$orgs\n"

read -p "Ready to clone your org repos (y/n)? " answer
case ${answer:0:1} in
    "y" | "Yes" )
        echo -e "\nCloning your org repos…"
        for org in $orgs; do
          echo -e "\nCreating $org directory for its repos…"
          mkdir -p "$org"
          cd "$org"

          for url in $(gh repo list "$org" --json sshUrl,name -q '.[] | .sshUrl'); do
            clone_repo "$url"
          done
          cd ..
        done
    ;;
    * )
        echo -e "\nExiting…"
        exit 0
    ;;
esac

echo -e "\nDone!"
