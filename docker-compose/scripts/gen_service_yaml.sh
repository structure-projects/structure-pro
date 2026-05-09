#!/bin/bash

gen_service_yaml() {
    local service_dir="$1"
    local is_darwin=0

    if [[ "$(uname)" == "Darwin" ]]; then
        is_darwin=1
    fi

    local env_file="${service_dir}/.env"
    if [ -f "${env_file}" ]; then
        while IFS= read -r line || [ -n "$line" ]; do
            if [[ "$line" =~ ^[[:space:]]*# ]]; then
                continue
            fi
            if [[ "$line" =~ ^[^=]+=.* ]]; then
                local var_name="${line%%=*}"
                local var_value="${line#*=}"
                var_value=$(echo "$var_value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

                if [ -f "${service_dir}/docker-compose.yaml" ]; then
                    if [ $is_darwin -eq 1 ]; then
                        sed -i '' "s|\${${var_name}}|${var_value}|g" "${service_dir}/docker-compose.yaml"
                        sed -i '' "s|\$(${var_name})|${var_value}|g" "${service_dir}/docker-compose.yaml"
                        sed -i '' "s|\$${var_name}|${var_value}|g" "${service_dir}/docker-compose.yaml"
                    else
                        sed -i "s|\${${var_name}}|${var_value}|g" "${service_dir}/docker-compose.yaml"
                        sed -i "s|\$(${var_name})|${var_value}|g" "${service_dir}/docker-compose.yaml"
                        sed -i "s|\$${var_name}|${var_value}|g" "${service_dir}/docker-compose.yaml"
                    fi
                fi

                if [ -f "${service_dir}/docker-compose.yml" ]; then
                    if [ $is_darwin -eq 1 ]; then
                        sed -i '' "s|\${${var_name}}|${var_value}|g" "${service_dir}/docker-compose.yml"
                        sed -i '' "s|\$(${var_name})|${var_value}|g" "${service_dir}/docker-compose.yml"
                        sed -i '' "s|\$${var_name}|${var_value}|g" "${service_dir}/docker-compose.yml"
                    else
                        sed -i "s|\${${var_name}}|${var_value}|g" "${service_dir}/docker-compose.yml"
                        sed -i "s|\$(${var_name})|${var_value}|g" "${service_dir}/docker-compose.yml"
                        sed -i "s|\$${var_name}|${var_value}|g" "${service_dir}/docker-compose.yml"
                    fi
                fi
            fi
        done < "${env_file}"

        if [ -f "${service_dir}/docker-compose.yaml" ]; then
            cp "${service_dir}/docker-compose.yaml" "${service_dir}/service.yaml"
            if [ $is_darwin -eq 1 ]; then
                sed -i '' "s|\${PWD}|${service_dir}|g" "${service_dir}/service.yaml"
            else
                sed -i "s|\${PWD}|${service_dir}|g" "${service_dir}/service.yaml"
            fi
        fi

        if [ -f "${service_dir}/docker-compose.yml" ]; then
            cp "${service_dir}/docker-compose.yml" "${service_dir}/service.yaml"
            if [ $is_darwin -eq 1 ]; then
                sed -i '' "s|\${PWD}|${service_dir}|g" "${service_dir}/service.yaml"
            else
                sed -i "s|\${PWD}|${service_dir}|g" "${service_dir}/service.yaml"
            fi
        fi
    fi
}