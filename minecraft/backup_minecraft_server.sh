#!/bin/bash

# requires environment variable DISCORD_ALERT_SCRIPT_PATH with path to function definition for send-discord-alert
# requires environment variable DISCORD_WEBHOOK_URL with url to desired webhook to use
# requires environment variable DISCORD_USER_ID with discord user id to be able to @
# requires environment variable MINECRAFT_DIR_PATH with a path to the application directory used by the services tied to minecraft
# requires environment variable RSYNC_USERNAME_SERVER_URL with a username and domain to auth into
# requires environment variable RSYNC_SERVER_DESTINATION_DIR_PATH with a path to the desired backup location
# requires environment variable RSYNC_PUB_KEY_PATH with a path to a valid public key to use to auth into rsync server

environment_variable_identifiers=( \
    "DISCORD_ALERT_SCRIPT_PATH" \
    "DISCORD_WEBHOOK_URL" \
    "DISCORD_USER_ID" \
    "MINECRAFT_DIR_PATH" \
    "RSYNC_USERNAME_SERVER_URL" \
    "RSYNC_SERVER_DESTINATION_DIR_PATH" \
    "RSYNC_PUB_KEY_PATH" \
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



source $DISCORD_ALERT_SCRIPT_PATH
now_date="$(date +%Y-%m-%d_%H-%M-%S)"
backup_name="pixelmon-backup.$now_date.XXXX.tar.gz"
data_dir_tar_tmp=$(mktemp -t $backup_name)
trap "rm -f $data_dir_tar_tmp" EXIT

function alert-dagon() {
    local message=$1
    echo $message
    discord_avatar_url="https://cdn-0.emojis.wiki/emoji-pics/apple/potato-apple.png"
    discord_username="Papa Checker 🥔"
    send-discord-alert "$DISCORD_WEBHOOK_URL" "<@$DISCORD_USER_ID>\n $(date +%Y-%m-%dT%H:%M:%SZ) $message" "$discord_username" "$discord_avatar_url"
}

tar -cvzf $data_dir_tar_tmp \
"$MINECRAFT_DIR_PATH/data/world" \
"$MINECRAFT_DIR_PATH/data/logs" \
"$MINECRAFT_DIR_PATH/data/banned-ips.json" \
"$MINECRAFT_DIR_PATH/data/banned-players.json" \
"$MINECRAFT_DIR_PATH/data/whitelist.json" \
"$MINECRAFT_DIR_PATH/data/ops.json"
tar_exit_code=$?


rsync -i "$RSYNC_PUB_KEY_PATH" -Pcauvh --stats "$data_dir_tar_tmp" "$RSYNC_USERNAME_SERVER_URL:$RSYNC_SERVER_DESTINATION_DIR_PATH"
rsync_exit_code=$?


if [[ $tar_exit_code -ne 0 ]] || [[ $rsync_exit_code -ne 0 ]]; then
    echo "ERROR: Tar Exit Code: $tar_exit_code, Rsync Exit Code: $rsync_exit_code"
    alert-dagon "ERROR: Couldn't perform successful backup ❌"
fi