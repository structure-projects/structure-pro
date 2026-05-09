#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
COMMON_SCRIPT="${PWD}/../../scripts/gen_service_yaml.sh"

mkdir -p ${PWD}/data
mkdir -p ${PWD}/rules
mkdir -p ${PWD}/grafana/provisioning/dashboards
mkdir -p ${PWD}/grafana/provisioning/datasources
mkdir -p ${PWD}/grafana/dashboards
mkdir -p ${PWD}/grafana/data

chown -R 472:472 data
chown -R 472:472 grafana

if [ -f "${COMMON_SCRIPT}" ]; then
    source "${COMMON_SCRIPT}"
    gen_service_yaml "${PARENT_DIR}"
fi