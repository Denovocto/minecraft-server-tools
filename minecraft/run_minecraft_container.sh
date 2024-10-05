#!/bin/bash

# requires environment variable MINECRAFT_OP with username of user to be server OP
# requires environment variable MINECRAFT_DIR_PATH with a path to the application directory used by the services tied to minecraft

environment_variable_identifiers=( \
    "MINECRAFT_OP" \
    "MINECRAFT_DIR_PATH" \
)

all_environment_variables_are_set=true
for identifier in ${environment_variable_identifiers[@]}; do
    if [[ ! -v $identifier ]]; then
        echo "ERROR: Environment Variable: $identifier is not set"
        all_environment_variables_are_set=false
    fi
done

if [[ "$all_environment_variables_are_set" != true ]]; then
    echo "ERROR: Not all environment variables were set"
    exit 1
fi

podman run --name minecraft-papa \
-d \
-it \
-p 25565:25565 \
-p 19565:19565 \
--env-file pixelmon.environment.txt \
-e OP=$MINECRAFT_OP \
-v "$MINECRAFT_DIR_PATH/data:/data:Z" \
-v "$MINECRAFT_DIR_PATH/config:/config:Z" \
--restart on-failure:3 \
--network minecraft \
--network-alias minecraft-papa \
itzg/minecraft-server:java11

sleep 10s

chown -R root:root "$MINECRAFT_DIR_PATH/data/"