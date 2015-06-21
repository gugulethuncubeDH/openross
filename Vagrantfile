# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # VirtualBox
  config.vm.box = "ubuntu/trusty64"
  config.vm.provider "virtualbox" do |v|
    v.memory = 1536
  end

  config.vm.network :forwarded_port, host: 8080, guest: 80
  config.vm.provision "shell", inline: <<-SHELL
    if ! `grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep --quiet nginx`
    then
      sudo add-apt-repository ppa:nginx/stable
    fi
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install -y libssl-dev python2.7-dev python-pip imagemagick libgraphicsmagick++1-dev libboost-python-dev nginx
    sudo pip install service_identity
    sudo pip install -e /vagrant/
    cp /vagrant/vagrant_support/openross.py ~/.openross.py
    if [ ! -d "/srv/cache" ]
    then
      mkdir /srv/cache/
    fi
    sudo chown -R www-data:www-data /srv/
    export PYTHONPATH=/vagrant/openross:$PYTHONPATH
    sudo cp /vagrant/vagrant_support/openross.init.d /etc/init.d/openross
    sudo chmod +x /etc/init.d/openross
    sudo service openross start
    if [ -f "/etc/nginx/sites-enabled/default" ]
    then
      sudo rm /etc/nginx/sites-enabled/default
    fi
    sudo cp /vagrant/vagrant_support/nginx.conf /etc/nginx/sites-enabled/openross
    sudo service nginx reload
  SHELL
end
