#!/bin/bash

# requires environment variable MINECRAFT_OP with username of user to be server OP
if [[ ! -v MINECRAFT_OP ]]; then
    echo "ERROR: Environment Variable: Minecraft_OP is not set."
fi

podman run --name minecraft-papa -d -it -p 25565:25565 --env-file pixelmon.environment.txt -e OP=$MINECRAFT_OP -v ./data:/data:Z -v ./config:/config:Z itzg/minecraft-server:java11