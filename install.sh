cp -r ./systemd-units/* /etc/systemd/system/
mkdir -p $HOME/applications/minecraft/data
mkdir -p $HOME/applications/minecraft/config
cp -r ./scripts/* $HOME/applications/minecraft
systemctl enable startup-minecraft-server.service
systemctl enable backup-minecraft-server.service
systemctl enable backup-minecraft-server.timer