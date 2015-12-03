#!/bin/bash 
set -e

# TODO: check for required env vars (e.g. $ENV_POOL_NAME, $CF_SPACE)

CF_APP_NAME=pricing

CF_DISPOSABLE_APP_NAME=$(cat test-environments/metadata)
echo "tearing down disposable stack ${CF_DISPOSABLE_APP_NAME}"

CF_ARGS=${CF_SPACE},${CF_DISPOSABLE_APP_NAME}

# TODO: don't re-install cf if it's already available in $PATH
wget "https://cli.run.pivotal.io/stable?release=debian64&source=github" -O /tmp/cf-cli.deb
dpkg -i /tmp/cf-cli.deb

bundle install --path=vendor/bundle --without production 

bundle exec rake cf:delete[$CF_ARGS] 
