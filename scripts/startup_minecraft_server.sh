#!/bin/bash

# requires environment variable DISCORD_ALERT_SCRIPT_PATH with path to function definition for send-discord-alert
# requires environment variable DISCORD_WEBHOOK_URL with url to desired webhook to use
# requires environment variable DISCORD_ROLE_REF_ID with role ID for mentions in server

environment_variable_identifiers=( \
    "DISCORD_ALERT_SCRIPT_PATH" \
    "DISCORD_WEBHOOK_URL" \
    "DISCORD_ROLE_REF_ID" \
)
all_environment_variables_are_set=true
all_path_environment_variables_are_valid=true
for identifier in ${environment_variable_identifiers[@]}; do
    if [[ ! -v $identifier ]]; then
        echo "ERROR: Environment Variable: $identifier is not set"
        all_environment_variables_are_set=false
    fi
    if [[ "$identifier" == *PATH ]]; then
        if [[ ! -e ${!identifier} ]]; then
            echo "ERROR: $identifier is not a valid path."
            all_path_environment_variables_are_valid=false
        fi
    fi
done

if [[ "$all_environment_variables_are_set" != true ]] || [[ "$all_path_environment_variables_are_valid" != true ]]; then
    echo "ERROR: Not all environment variables were valid"
    exit 1
fi

function alert-dagon() {
    local message=$1
    echo $message
    discord_avatar_url="https://cdn-0.emojis.wiki/emoji-pics/apple/potato-apple.png"
    discord_username="Papa Checker 🥔"
    send-discord-alert "$DISCORD_WEBHOOK_URL" "<@&$DISCORD_ROLE_REF_ID>\n $(date +%Y-%m-%dT%H:%M:%SZ) $message" "$discord_username" "$discord_avatar_url"
}

source $DISCORD_ALERT_SCRIPT_PATH

podman start minecraft-papa && playit-linux-amd64

alert-dagon "INFO: Potato Minecraft Server startup initiated ✅"