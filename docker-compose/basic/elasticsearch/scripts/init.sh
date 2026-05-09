#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
COMMON_SCRIPT="${PWD}/../../scripts/gen_service_yaml.sh"

mkdir -p ${PWD}/data/data
mkdir -p ${PWD}/data/backup
mkdir -p ${PWD}/data/conf

chown -R 1000:1000 data

if [ -f "${COMMON_SCRIPT}" ]; then
    source "${COMMON_SCRIPT}"
    gen_service_yaml "${PARENT_DIR}"
fi