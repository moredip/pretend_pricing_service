#!/bin/bash 
set -e

# TODO: check for required env variables (CF_SPACE)

DEPLOY_UID=$(ruby -r securerandom -e "print SecureRandom.uuid.split('-').first") # Concourse doesn't give us a build guid :(
CF_DISPOSABLE_APP_NAME=${CF_APP_NAME}__${DEPLOY_UID}
CF_ARGS=${CF_SPACE},${CF_DISPOSABLE_APP_NAME}

# TODO: don't re-install cf if it's already available in $PATH
wget "https://cli.run.pivotal.io/stable?release=debian64&source=github" -O /tmp/cf-cli.deb
dpkg -i /tmp/cf-cli.deb

bundle install --path=vendor/bundle --without production 

bundle exec rake cf:cups[$CF_ARGS]
bundle exec rake cf:deploy[$CF_ARGS] 
