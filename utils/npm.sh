#!/bin/sh

echo "node -v"
node -v
if [[ $? != 0 ]]; then
    echo "node not found, installing via homebrew"
    brew install node
    node -v
fi

echo "Updating npm..."
sudo npm install npm@latest -g
npm -v

sudo npm i core-util-is

# always pin versions (no surprises, consistent dev/build machines)
sudo npm config set save-exact true

# Install npm packages globally without sudo on macOS
cd ~ && mkdir "${HOME}/.npm-packages"         # Create a directory for global packages
npm config set prefix "${HOME}/.npm-packages" # Tell npm where to store globally installed packages

##############################################################################################################

echo "Installing NPM utilities..."

npm_formulas=(
    "fkill-cli"
    "speed-test"
    "undollar"
    "trash-cli"
    "npm-check-updates"
    "vtop"
    "spoof"
    "iponmap"
    "is-up"
    "is-online"
    "emoj"
    "gh-home"
    "webtorrent-cli"
    "dark-mode-cli"
    "cash-cli"
    "cost-of-modules"
    "subdownloader"
    "kill-tabs"
    "normit"
    "npm-check"
    "fast-cli"
)

# Install npm utilities
for ((i = 0; i < ${#npm_formulas[@]}; i++)); do
    sudo npm install --global ${npm_formulas[i]}
done

# Pip
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py

pip install termdown