#!/usr/bin/env bash


timestamp=$(date +"%T")
echo "::set-output name=deploy_version::$timestamp"
echo "::set-output name=deploy_path::$1/$timestamp"
