#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXTRAS_DIR="$SCRIPT_DIR/Extras"

echo "Last Warning! If you aren't me, you will maybe hate this."

sleep 10

echo "K fuckwit."

yay -S syncthing obsidian discord flatpak floorp audacity obs-studio rust --noconfirm --needed

wget https://raw.githubusercontent.com/syncthing/syncthing/refs/heads/main/etc/linux-systemd/user/syncthing.service /tmp/syncthing.service
sudo mv /tmp/syncthing.service /etc/systemd/user/syncthing.service
systemctl --user enable --now syncthing.service

sudo pacman -Rss firefox --noconfirm

flatpak install -y flathub com.spotify.Client

yay -S spicetify-cli --needed
spicetify config spotify_path "/var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify"
spicetify config prefs_path /home/$USER/.var/app/com.spotify.Client/config/spotify/prefs
sudo chmod a+wr /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify
sudo chmod a+wr -R /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify/Apps
spicetify backup apply
curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh

mkdir -p "$EXTRAS_DIR/tmp"
cd "$EXTRAS_DIR/tmp"
git clone --depth=1 https://github.com/spicetify/spicetify-themes.git 
cd spicetify-themes
cp -r * ~/.config/spicetify/Themes
spicetify config current_theme Sleek
spicetify config color_scheme Psycho
spicetify apply

echo "$USER ALL=(ALL) NOPASSWD: /usr/local/bin/scx_cake
%wheel ALL=(ALL) NOPASSWD: /usr/local/bin/scx_cake" | sudo tee /etc/sudoers.d/scx_cake >/dev/null
sudo chmod 440 /etc/sudoers.d/scx_cake

mkdir -p "$EXTRAS_DIR/scx_cake"
cd "$EXTRAS_DIR"
if [ ! -d "scx_cake" ]; then
  git clone https://github.com/RitzDaCat/scx_cake.git -b nightly
fi
cd scx_cake
./build.sh
sudo install -Dm755 ./target/release/scx_cake /usr/local/bin/scx_cake

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
