#!/usr/bin/env bash


time=$(date)
echo "::set-output deploy_version=time::$time"
echo "::set-output deploy_path=$1/$time"
