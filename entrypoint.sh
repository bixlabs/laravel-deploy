#!/usr/bin/env bash

set -e

if [ $# -lt 6 ]; then
  echo "not enough arguments ro run"
  exit 1
fi

deploy_dir="$1"
source_dir="$2"
deploy_host="$3"
deploy_username="$4"
post_deploy="$5"
deploy_key=$(echo "${@: 6}" | tr ' ' '\n' )

script_dir="$( cd "$( dirname "$0" )" && pwd )"
deploy_key_path="$script_dir/.key"

timestamp=$(date +%Y-%m-%d_%H-%M-%S)
deploy_version="$timestamp"
deploy_path="$deploy_dir/releases/$timestamp"

# LOCAL FUNCTIONS
debug() {
  echo "::debug::$*"
}

error() {
  echo "::error ::$*"
}

prepare_deploy_key() {
  echo "-----BEGIN RSA PRIVATE KEY-----" > "$deploy_key_path"
  for part in $deploy_key; do
    if ! echo "$part" | grep -q -E "BEGIN|RSA|PRIVATE|KEY|END" ; then
      echo "$part" >> "$deploy_key_path"
    fi
  done
  echo "-----END RSA PRIVATE KEY-----" >> "$deploy_key_path"
  chmod 400 "$deploy_key_path"
}

validate_deploy_target() {
  if ssh -q -i "$deploy_key_path" -o StrictHostKeyChecking=no -o ConnectTimeout=5 -T "$deploy_username@$deploy_host" 'exit 0'; then
    debug "ssh $deploy_username@$deploy_host is successful"
  else
    error "not able to connect to $deploy_username@$deploy_host"
    exit 1
  fi
}

deploy_source_dir() {
  if [ ! -d "$source_dir" ]; then
    error "$source_dir does not exists"
    exit 1
  fi

  rsync -e "ssh -i $deploy_key_path -o StrictHostKeyChecking=no" -avzr --quiet --delete "$source_dir/" "$deploy_username@$deploy_host:$deploy_path/"
}
# END LOCAL FUNCTIONS

# REMOTE FUNCTIONS
prepare_deploy_dir() {
  # shellcheck disable=SC2087
  ssh -i "$deploy_key_path" -o BatchMode=yes -o StrictHostKeyChecking=no "$deploy_username@$deploy_host" bash <<EOF

  debug() {
    echo "::debug::\$*"
  }

  error() {
    echo "::error ::\$*"
  }


  if [ ! -d $deploy_dir ]; then
      debug "creating '$deploy_dir'"
      mkdir -p $deploy_dir
  else
      debug "using current $deploy_dir"
  fi

  if [ "\$(ls -A $deploy_dir)" = "" ]; then
    debug "creating internal structure"
    mkdir -p $deploy_dir/{releases,shared}
  elif [ ! -d $deploy_dir/releases  ] && [ ! -d $deploy_dir/releases  ] ; then
    error "$deploy_dir cannot be used, is not empty or a valid deploy dir"
    exit 1
  fi

  debug "creating deploy path '$deploy_path'"
  mkdir -p $deploy_path

  if [ ! "\$(ls -A $deploy_dir/current)" = "" ]; then
    debug "previous deploy \$(readlink -f $deploy_dir/current)"
  fi

  ln -sfn $deploy_path $deploy_dir/current

  cd $deploy_dir/current

  $post_deploy
EOF
}
# END REMOTE FUNCTIONS

echo "::add-mask::$deploy_key_path"
echo "::add-mask::$deploy_username"

# step 1
prepare_deploy_key
# step 2
validate_deploy_target
# step 3
prepare_deploy_dir
# step 4
deploy_source_dir


echo "::set-output name=deploy_version::$deploy_version"
echo "::set-output name=deploy_path::$deploy_path"
