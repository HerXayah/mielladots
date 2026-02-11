#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
XDG_DATA_HOME=`[[ -z "$XDG_DATA_HOME" ]] && echo -n "$HOME/.local/share" || echo -n "$XDG_DATA_HOME"`
XDG_CACHE_HOME=`[[ -z "$XDG_CACHE_HOME" ]] && echo -n $HOME/.cache || echo -n $XDG_CACHE_HOME`
XDG_CONFIG_HOME=`[[ -z "$XDG_CONFIG_HOME" ]] && echo -n "$HOME/.config" || echo -n "$XDG_CONFIG_HOME"`
BIN_HOME=`[[ -z "$BIN_HOME" ]] && echo -n "$HOME/.local/bin" || echo -n "$BIN_HOME"`
APPS_HOME=`[[ -z "$APPS_HOME" ]] && echo -n "$XDG_DATA_HOME/applications" || echo -n "$APPS_HOME"`

EXTRAS_DIR="$SCRIPT_DIR/Extras"
COLORSHELL_DIR="$EXTRAS_DIR/colorshell"

yay -Syu --needed --noconfirm \
  git stow uwsm pokemon-colorscripts-git ocs-url rofi alacritty \
  grim slurp gobject-introspection ttf-nerd-fonts-symbols-mono curl \
  hyprland hypridle hyprlock hyprpaper socat hyprpicker cliphist \
  wireplumber networkmanager pipewire dart-sass glycin glycin-gtk4 \
  ibus procps-ng hyprpolkitagent jq pnpm gjs typescript \
  aylurs-gtk-shell-git libastal-meta python-pywal16 \
  hyprshot hyprsunset wf-recorder overskride
sudo systemctl enable --now NetworkManager
systemctl enable --user hyprpaper.service

mkdir -p "$EXTRAS_DIR"
cd "$EXTRAS_DIR"
if [ ! -d "colorshell" ]; then
  git clone https://github.com/retrozinndev/colorshell
fi
cd colorshell
pnpm i && pnpm update
pnpm build:release

mkdir -p $XDG_DATA_HOME/colorshell
mkdir -p $BIN_HOME
mkdir -p $APPS_HOME

echo "Installing colorshell..."
echo "Installing colorshell to $BIN_HOME and desktop entry to $APPS_HOME"
cp -f ./build/release/resources.gresource $XDG_DATA_HOME/colorshell
mv ./build/release/colorshell $BIN_HOME/colorshell
mv ./build/release/colorshell.desktop $APPS_HOME/colorshell.desktop

mkdir -p $XDG_CONFIG_HOME/hypr/scripts
cp ./config/hypr/scripts/gen-pywal.sh $XDG_CONFIG_HOME/hypr/scripts/gen-pywal.sh
cp ./config/hypr/scripts/color-picker.sh $XDG_CONFIG_HOME/hypr/scripts/color-picker.sh
cp ./config/hypr/scripts/exec.sh $XDG_CONFIG_HOME/hypr/scripts/exec.sh
cp ./config/hypr/scripts/change-wallpaper.sh $XDG_CONFIG_HOME/hypr/scripts/change-wallpaper.sh

chmod +x $XDG_CONFIG_HOME/hypr/scripts/gen-pywal.sh
chmod +x $XDG_CONFIG_HOME/hypr/scripts/color-picker.sh
chmod +x $XDG_CONFIG_HOME/hypr/scripts/exec.sh
chmod +x $XDG_CONFIG_HOME/hypr/scripts/change-wallpaper.sh
chmod +x $BIN_HOME/colorshell
chmod +x $APPS_HOME/colorshell.desktop
chmod +x $XDG_DATA_HOME/colorshell/resources.gresource

mkdir -p $XDG_CONFIG_HOME/hypr/sources
cat ./config/hypr/shell/rules.conf >> $XDG_CONFIG_HOME/hypr/sources/customwindows.conf

echo "Copying default wallpaper to $HOME/wallpapers/Default Hypr-chan.jpg"
mkdir -p $HOME/wallpapers
cp -f ./resources/wallpaper_default.jpg "$HOME/wallpapers/Default Hypr-chan.jpg"

cd "$SCRIPT_DIR"
stow .

read -p "Is your name Miella? y or n?" yn
case $yn in
    [Yy]* ) sh "$EXTRAS_DIR/miella.sh";;
    [Nn]* ) echo "Installation complete! You can now run 'colorshell' from your terminal or find it in your application launcher.";;
    * ) echo "Please answer yes or no.";;
esac
