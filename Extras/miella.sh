#!/bin/bash

echo "Last Warning! If you aren't me, you will maybe hate this."

sleep 10

echo "K fuckwit."

yay -S syncthing --needed

wget -c https://raw.githubusercontent.com/syncthing/syncthing/refs/heads/main/etc/linux-systemd/user/syncthing.service  /tmp/syncthing.service
sudo mv /tmp/syncthing.service /etc/systemd/user/syncthing.service
sudo systemctl --user enable --now syncthing.service

yay -S obsidian discord flatpak floorp --needed
sudo pacman -Rss firefox --noconfirm

flatpak install flathub com.spotify.Client

# im mentally insane

yay -S spicetify-cli --needed
spicetify config spotify_path "/var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify"
spicetify config prefs_path /home/$USER/.var/app/com.spotify.Client/config/spotify/prefs
sudo chmod a+wr /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify
sudo chmod a+wr -R /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify/Apps
spicetify backup apply
curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh
cd /tmp/
git clone --depth=1 https://github.com/spicetify/spicetify-themes.git 
cd spicetify-themes
cp -r * ~/.config/spicetify/Themes
spicetify config current_theme Sleek
spicetify config color_scheme Psycho
spicetify apply

yay -S audacity obs-studio --needed

echo "Exiting installer, you can now run 'colorshell' from your terminal or find it in your application launcher."