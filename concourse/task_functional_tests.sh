#!/bin/bash 
set -e

DEPLOY_UID=$(ruby -r securerandom -e "print SecureRandom.uuid.split('-').first") # Concourse doesn't give us a build guid :(
CF_SPACE=test
CF_APP_NAME=pricing
CF_DISPOSABLE_APP_NAME=${CF_APP_NAME}__${DEPLOY_UID}
CF_ARGS=${CF_SPACE},${CF_DISPOSABLE_APP_NAME}

# TODO: don't re-install cf if it's already available in $PATH
wget "https://cli.run.pivotal.io/stable?release=debian64&source=github" -O /tmp/cf-cli.deb
dpkg -i /tmp/cf-cli.deb

bundle install --path=vendor/bundle --without production 

# it'd be better if we could clean up via CD, but Concourse's `ensure` primitive doesn't quite cut it yet. https://concourseci.slack.com/archives/general/p1448505120002526
function teardown {
  bundle exec rake cf:delete[$CF_ARGS] 
}
trap teardown EXIT

bundle exec rake cf:deploy[$CF_ARGS] 

BASE_URL=http://pricing-$CF_DISPOSABLE_APP_NAME.cfapps.io bundle exec rake spec:functional
