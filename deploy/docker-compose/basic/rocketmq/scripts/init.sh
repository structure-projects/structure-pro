#!/bin/bash

mkdir -p ${PWD}/data/broker/logs
mkdir -p ${PWD}/data/broker/store
mkdir -p ${PWD}/data/broker/conf
mkdir -p ${PWD}/data/namesrv/logs
mkdir -p ${PWD}/data/proxy/logs
mkdir -p ${PWD}/data/proxy/conf

chown -R 3000:3000 data