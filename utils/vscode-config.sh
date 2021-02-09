#!/bin/sh

cd ~ && cd ~/Library/Application\ Support/Code/User/
rm .vscode_settings.json
rm settings.json
rm extensions.json
rm keybindings.json
rm keybindingsMac.json

cd ~ && cd ${HOME}/dotfiles/vscode-config
ln -s .vscode_settings.json ~/Library/Application\ Support/Code/User/.vscode_settings.json
ln -s settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -s extensions.json ~/Library/Application\ Support/Code/User/extensions.json
ln -s keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
ln -s keybindingsMac.json ~/Library/Application\ Support/Code/User/keybindingsMac.json
