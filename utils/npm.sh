#!/bin/sh

sudo npm install npm@latest -g

# always pin versions (no surprises, consistent dev/build machines)
sudo npm config set save-exact true

# Install npm packages globally without sudo on macOS
if [ ! -d "${HOME}/.npm-packages" ]; then
    cd ~ && mkdir "${HOME}/.npm-packages"     # Create a directory for global packages
fi

npm config set prefix "${HOME}/.npm-packages" # Tell npm where to store globally installed packages

##############################################################################################################

npm_formulas=(
    "core-util-is"
    "undollar"
    "spoof"
    "gh-home"
    "subdownloader"
    "kill-tabs"
    "fast-cli"
)

# Install npm utilities
for ((i = 0; i < ${#npm_formulas[@]}; i++)); do
    sudo npm install --global ${npm_formulas[i]}
done
