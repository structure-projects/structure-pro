#!/bin/bash

mkdir -p ${PWD}/data
mkdir -p ${PWD}/rules
mkdir -p ${PWD}/grafana/provisioning/dashboards
mkdir -p ${PWD}/grafana/provisioning/datasources
mkdir -p ${PWD}/grafana/dashboards
mkdir -p ${PWD}/grafana/data

chown -R 472:472 data