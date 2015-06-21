# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # VirtualBox
  config.vm.box = "ubuntu/trusty64"
  config.vm.provider "virtualbox" do |v|
    v.memory = 1536 # Dependencies won't compile with <1.5GB memory
  end

  config.vm.network :forwarded_port, host: 8080, guest: 80
  config.vm.provision "shell", inline: <<-SHELL
    # Adds nginx/stable to apt-get source if it's not there, allow newer nginx versions
    if ! `grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep --quiet nginx`
    then
      sudo add-apt-repository ppa:nginx/stable
    fi
    # Update apt-get indexes
    sudo apt-get update
    # Lets stay up to date with versions
    sudo apt-get upgrade -y
    # Install dependencies
    sudo apt-get install -y libssl-dev python2.7-dev python-pip imagemagick libgraphicsmagick++1-dev libboost-python-dev nginx
    sudo pip install service_identity
    sudo pip install -e /vagrant/
    # OpenRoss settings
    cp /vagrant/vagrant_support/openross.py ~/.openross.py
    # Make the cache folder if it's needed
    if [ ! -d "/srv/cache" ]
    then
      mkdir /srv/cache/
    fi
    # For nginx access, www-data should own /srv/
    sudo chown -R www-data:www-data /srv/
    # twistd can't find openross, fix it
    export PYTHONPATH=/vagrant/openross:$PYTHONPATH
    # init.d service for openross
    sudo cp /vagrant/vagrant_support/openross.init.d /etc/init.d/openross
    sudo chmod +x /etc/init.d/openross
    # Starts openross from init.d file
    sudo service openross start
    # Deletes default nginx site if it exists
    if [ -f "/etc/nginx/sites-enabled/default" ]
    then
      sudo rm /etc/nginx/sites-enabled/default
    fi
    # Copy our nginx configuration in to place
    sudo cp /vagrant/vagrant_support/nginx.conf /etc/nginx/sites-enabled/openross
    # Reload nginx config
    sudo service nginx reload
  SHELL
end
