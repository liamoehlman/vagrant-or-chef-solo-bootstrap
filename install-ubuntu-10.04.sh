#!/bin/bash
# This runs as root on the server

chef_binary=/opt/ruby/bin/chef-solo

# Are we on a vanilla system?
if ! test -f "$chef_binary"; then
apt-get -y update
apt-get -y upgrade
apt-get -y install linux-headers-$(uname -r) build-essential
apt-get -y install zlib1g-dev libssl-dev libreadline5-dev
apt-get clean

wget http://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p334.tar.gz
tar xvzf ruby-1.8.7-p334.tar.gz
cd ruby-1.8.7-p334
./configure --prefix=/opt/ruby
make
make install
cd ..
rm -rf ruby-1.8.7-p334*

# Install RubyGems 1.8.17
wget http://production.cf.rubygems.org/rubygems/rubygems-1.8.17.tgz
tar xzf rubygems-1.8.17.tgz
cd rubygems-1.8.17
/opt/ruby/bin/ruby setup.rb
cd ..
rm -rf rubygems-1.8.17*

# Installing chef & Puppet
/opt/ruby/bin/gem install chef --no-ri --no-rdoc

fi &&

"$chef_binary" -c solo.rb -j solo.json




