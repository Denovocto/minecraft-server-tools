#!/bin/bash

# requires PROMETHEUS_DIR_PATH with path to prometheus application directory

environment_variable_identifiers=( \
    "PROMETHEUS_DIR_PATH" \
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

podman run --name prometheus \
-d \
-it \
-p 1010:9090 \
-v "$PROMETHEUS_DIR_PATH/prometheus.yml:/etc/prometheus/prometheus.yml:Z" \
--restart on-failure:3 \
--network chonkatronic-services \
--network-alias prometheus \
bitnami/prometheus