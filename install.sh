cp -r ./systemd-units/* /etc/systemd/system/
mkdir -p $HOME/applications/minecraft/data
mkdir -p $HOME/applications/minecraft/config
mkdir -p $HOME/applications/grafana/data
mkdir -p $HOME/applications/prometheus
cp -r ./minecraft/* $HOME/applications/minecraft
cp -r ./prometheus/* $HOME/applications/prometheus
cp -r ./grafana/* $HOME/applications/grafana
systemctl enable startup-minecraft-server.service
systemctl enable startup-grafana.service
systemctl enable startup-prometheus.service
systemctl enable backup-minecraft-server.timer