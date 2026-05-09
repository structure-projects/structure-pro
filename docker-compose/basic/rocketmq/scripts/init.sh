#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
COMMON_SCRIPT="${PWD}/../../scripts/gen_service_yaml.sh"

mkdir -p ${PWD}/data/broker/logs
mkdir -p ${PWD}/data/broker/store
mkdir -p ${PWD}/data/broker/conf
mkdir -p ${PWD}/data/namesrv/logs
mkdir -p ${PWD}/data/proxy/logs
mkdir -p ${PWD}/data/proxy/conf

chown -R 3000:3000 data

if [ -f "${COMMON_SCRIPT}" ]; then
    source "${COMMON_SCRIPT}"
    gen_service_yaml "${PARENT_DIR}"
fi