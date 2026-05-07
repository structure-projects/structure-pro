#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
COMMON_SCRIPT="${PWD}/../../scripts/gen_service_yaml.sh"

mkdir -p ${PWD}/data

DIR="${PWD}/data/"

if [ -d "$DIR" ]; then
  echo "目录 $DIR 已存在"
else
  echo "目录 $DIR 不存在，正在创建..."
  mkdir -p "$DIR"
  if [ $? -eq 0 ]; then
    echo "目录 $DIR 创建成功"
  else
    echo "目录 $DIR 创建失败"
  fi
fi

chown -R 1001:1001 $DIR

if [ -f "${COMMON_SCRIPT}" ]; then
    source "${COMMON_SCRIPT}"
    gen_service_yaml "${PARENT_DIR}"
fi