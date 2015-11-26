#!/bin/bash 
bundle install --path=vendor/bundle --without production 
bundle exec rake spec:unit
