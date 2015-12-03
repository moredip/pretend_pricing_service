#!/bin/bash 
set -e

CF_DISPOSABLE_APP_NAME=$(cat test-environments/metadata)
echo "testing against disposable stack ${CF_DISPOSABLE_APP_NAME}"

bundle install --path=vendor/bundle --without production 

BASE_URL=http://pricing-$CF_DISPOSABLE_APP_NAME.cfapps.io bundle exec rake spec:functional
