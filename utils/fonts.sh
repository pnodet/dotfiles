#!/bin/sh

function require_cask() {
    echo "brew cask $1"
    brew list $1 --cask >/dev/null 2>&1 | true
    if [[ ${PIPESTATUS[0]} != 0 ]]; then
        echo "brew install $1 $2 --cask"
        brew install $1 --cask
        if [[ $? != 0 ]]; then
            echo "failed to install $1! aborting..."
            # exit -1
        fi
    fi
}

declare -a fonts_utils=(
    'fontconfig'       # need fontconfig to install/build fonts
    'sfnt2woff'        #Font tools
    'sfnt2woff-zopfli' #Font tools
    'woff2'            #Font tools
)

for util in "${fonts_utils[@]}"; do
    require_cask "$util"
done

declare -a brew_cask_fonts=(
    'font-fontawesome'
    'font-awesome-terminal-fonts'
    'font-roboto-mono'
    'font-source-code-pro'
    'font-fira-code'
    'font-fira-mono'
    'font-firacode-nerd-font'
    'font-firacode-nerd-font-mono'
)

for font in "${brew_cask_fonts[@]}"; do
    require_cask "$font"
done