#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Last Warning! If you aren't me, you will maybe hate this."

sleep 10

echo "K fuckwit."

yay -S syncthing obsidian discord flatpak floorp-bin audacity obs-studio rust unzip git base-devel spicetify-cli --noconfirm --needed

systemctl --user enable --now syncthing.service

sudo pacman -Rns firefox --noconfirm || true

flatpak install -y flathub com.spotify.Client

flatpak run com.spotify.Client &

PREFS_PATH="$HOME/.var/app/com.spotify.Client/config/spotify/prefs"

while [ ! -f "$PREFS_PATH" ]; do
  sleep 1
done

pkill spotify || true

SPOTIFY_PATH="$(flatpak info --show-location com.spotify.Client)/files/extra/share/spotify"

spicetify config spotify_path "$SPOTIFY_PATH"
spicetify config prefs_path "$PREFS_PATH"

sudo chown -R "$USER:$USER" "$SPOTIFY_PATH"

spicetify backup apply

curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh

cd "$SCRIPT_DIR"

if [ ! -d "spicetify-themes/.git" ]; then
  git clone --depth=1 https://github.com/spicetify/spicetify-themes.git
fi

mkdir -p ~/.config/spicetify/Themes
cp -r spicetify-themes/* ~/.config/spicetify/Themes

spicetify config current_theme Sleek
spicetify config color_scheme Psycho
spicetify apply

cd "$SCRIPT_DIR"

if [ ! -d "scx_cake/.git" ]; then
  git clone https://github.com/RitzDaCat/scx_cake.git -b nightly
fi

cd scx_cake
./build.sh

sudo install -Dm755 ./target/release/scx_cake /usr/local/bin/scx_cake

echo "$USER ALL=(ALL) NOPASSWD: /usr/local/bin/scx_cake
%wheel ALL=(ALL) NOPASSWD: /usr/local/bin/scx_cake" | sudo tee /etc/sudoers.d/scx_cake >/dev/null

sudo chmod 440 /etc/sudoers.d/scx_cake

sudo tee /etc/systemd/system/scx_cake.service >/dev/null <<'EOF'
[Unit]
Description=scx_cake sched_ext Scheduler
After=multi-user.target
ConditionPathExists=/usr/local/bin/scx_cake

[Service]
Type=exec
ExecStart=/usr/local/bin/scx_cake
Restart=always
RestartSec=0
CapabilityBoundingSet=CAP_SYS_ADMIN CAP_SYS_NICE CAP_BPF
AmbientCapabilities=CAP_SYS_ADMIN CAP_SYS_NICE CAP_BPF
NoNewPrivileges=false

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now scx_cake.service

echo "Exiting installer."
