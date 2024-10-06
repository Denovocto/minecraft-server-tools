mkdir -p $HOME/applications/minecraft/data/
mkdir -p $HOME/applications/minecraft/config/
mkdir -p $HOME/applications/grafana/data/
mkdir -p $HOME/applications/prometheus/
cp -r ./systemd-units/* $HOME/.config/systemd/user
cp -r ./minecraft/* $HOME/applications/minecraft
cp -r ./prometheus/* $HOME/applications/prometheus
cp -r ./grafana/* $HOME/applications/grafana
systemctl enable --user startup-prometheus.service
systemctl enable --user startup-grafana.service
systemctl enable --user startup-minecraft-server.service
systemctl enable --user backup-minecraft-server.timer

systemctl --user daemon-reload