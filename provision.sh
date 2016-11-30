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

echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list

apt-get update

apt-get install -y mongodb-org=3.2.10 mongodb-org-server=3.2.10 mongodb-org-shell=3.2.10 mongodb-org-mongos=3.2.10 mongodb-org-tools=3.2.10

cp /vagrant/mongodb.service /etc/systemd/system
systemctl start mongodb

# Install Node
apt-get install -y nodejs npm

cd /vagrant

bundle install

# phantomjs tries to use 'node' whne the binary is 'nodejs' see:
# for details: http://stackoverflow.com/questions/18130164/nodejs-vs-node-on-ubuntu-12-04
update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10

npm install --no-bin-link

npm install -g grunt-cli

if [ ! -f .env ]; then
  cp /vagrant/template.env /vagrant/.env

  echo "******************************"
  echo "Update the constants in '.env'"
  echo "******************************"
fi

#Next time, on Dev Ops Guild!
#Todo:
# Forward port 4000
# Create a DevOpsGuild Trello account
# Populate the .env file
# automate retrieval of the board edit token for .env file (rake test::setup)
# Have fun!!
#Follow instructions to run the tests
#
