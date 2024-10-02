#!/bin/bash

# requires GRAFANA_DIR_PATH with path to grafana application directory

environment_variable_identifiers=( \
    "GRAFANA_DIR_PATH" \
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

podman run --name grafana \
-d \
-it \
-p 3000:3000 \
-v "$GRAFANA_DIR_PATH/data:/var/lib/grafana:Z" \
--restart on-failure:3 \
--network minecraft \
--network-alias grafana \
grafana/grafana