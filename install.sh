#!/usr/bin/env bash

BIN_HOME=`[[ -z "$BIN_HOME" ]] && echo -n "$HOME/.local/bin" || echo -n "$BIN_HOME"`
APPS_HOME=`[[ -z "$APPS_HOME" ]] && echo -n "$XDG_DATA_HOME/applications" || echo -n "$APPS_HOME"`

COLORSHELL_DIR="$PWD/Extras/colorshell"

# git clone the shell (skip if already exists)
cd ./Extras/
if [ ! -d "colorshell" ]; then
  git clone https://github.com/retrozinndev/colorshell
fi
cd colorshell
#pnpm -C "$repo_directory" i && pnpm -C "$repo_directory" update
pnpm i && pnpm update
pnpm build:release


mkdir -p $XDG_DATA_HOME/colorshell

# Move from current directory (we're in colorshell/ now)
echo "Installing colorshell..."
echo "Installing colorshell to $BIN_HOME and desktop entry to $APPS_HOME"
#cp -f $repo_directory/build/release/resources.gresource $XDG_DATA_HOME/colorshell
cp -f ./build/release/resources.gresource $XDG_DATA_HOME/colorshell
mv ./build/release/colorshell $BIN_HOME/colorshell
mv ./build/release/colorshell.desktop $APPS_HOME/colorshell.desktop

# Copying scripts we need

cp ./scripts/gen-pywal.sh $XDG_CONFIG_HOME/hypr/scripts/gen-pywal.sh
cp ./scripts/color-picker.sh $XDG_CONFIG_HOME/hypr/scripts/color-picker.sh

# copy rules into our file, because leeches get beeches
mv ./config/hypr/shell/rules.conf >> $XDG_CONFIG_HOME/hypr/sources/customwindows.conf