#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
COMMON_SCRIPT="${PWD}/../../scripts/gen_service_yaml.sh"

mkdir -p ${PWD}/clickhouse
mkdir -p ${PWD}/clickhouse-server

if [ -f "${COMMON_SCRIPT}" ]; then
    source "${COMMON_SCRIPT}"
    gen_service_yaml "${PARENT_DIR}"
fi