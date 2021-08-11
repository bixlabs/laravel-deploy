#!/usr/bin/env bash


timestamp=$(date +%Y-%m-%d_%H-%M-%S)
deploy_version="$timestamp"
deploy_path="${1:-1/var/www/html}/${deploy_version}"

echo "::set-output name=deploy_version::$deploy_version"
echo "::set-output name=deploy_path::$deploy_path"
