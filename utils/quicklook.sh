#!/bin/sh

function require_brew() {
  echo "brew $1 $2"
  brew list $1 >/dev/null 2>&1 | true
  if [[ ${PIPESTATUS[0]} != 0 ]]; then
    echo "brew install $1 $2"
    brew install $1 $2
    if [[ $? != 0 ]]; then
      echo "failed to install $1! aborting..."
      # exit -1
    fi
  fi
  echo "done"
}

xattr -d -r com.apple.quarantine ~/Library/QuickLook

plugin_formulas=(
    'qlcolorcode'
    'qlstephen'
    'qlmarkdown'
    'quicklook-json'
    'quicklook-csv'
    'qlimagesize'
    'qlvideo'
    'apparency'
    'WebPQuickLook'
    'suspicious-package'
)

for plugin in "${plugin_formulas[@]}"; do
    require_brew "$plugin"
done

qlmanage -r