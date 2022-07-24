#!/bin/sh

# always pin versions (no surprises, consistent dev/build machines)
savExact=$(sudo npm config get save-exact)
if [ savExact = false ]; then
    sudo npm config set save-exact true
fi

# Install npm packages globally without sudo on macOS
if [ ! -d "${HOME}/.npm-packages" ]; then
    cd ~ && mkdir "${HOME}/.npm-packages"     # Create a directory for global packages
fi

npm config set prefix "${HOME}/.npm-packages" # Tell npm where to store globally installed packages
