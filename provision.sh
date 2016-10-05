#!/bin/bash
set -e

apt-get update

# Install Ruby
apt-get -y install libxslt-dev libxml2-dev build-essential libqtwebkit-dev curl

curl -sSL https://rvm.io/mpapis.asc | gpg --import -

curl -sSL https://get.rvm.io | bash -s stable

source /etc/profile.d/rvm.sh

rvm install 2.3.1

rvm use 2.3.1

gem install bundler

# Install Mongo
# - TODO: parameterize mongodb version number
# - TODO: find out which version of mongodb we're actually using on heroku/mlab
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927

echo "deb http://repo.mongodb.org/apt/ubuntu precise/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list

apt-get update

apt-get install -y mongodb-org=3.2.10 mongodb-org-server=3.2.10 mongodb-org-shell=3.2.10 mongodb-org-mongos=3.2.10 mongodb-org-tools=3.2.10

update-rc.d mongod defaults

# Install Node
apt-get install -y nodejs npm
