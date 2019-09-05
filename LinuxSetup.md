# Linux Setup
1. Install [RVM](https://rvm.io/rvm/install), [Ruby](https://www.ruby-lang.org/en/), and [Rails](http://rubyonrails.org/) using the guide

    ```
    ### Downloads and installs RVM
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    \curl -sSL https://get.rvm.io | bash

    ### Add the following line to your .bashrc or .zshrc
    source $HOME/.rvm/scripts/rvm

    ### Switch to project directory
    cd <path to project>

    ### Install Ruby v2.3.0 with RVM
    rvm install ruby-2.3.0
    ruby -v

    ### Install Rails v5 with gem
    ### --pre : pre-release (allows download of Rails 5)
    gem install rails --pre
    rails -v
    ```

2. Install [Postgres 9.4 for Ubuntu](http://www.postgresql.org/download/linux/ubuntu/)

    ```
    ### Append the apt repository URL to source list
    ### "trusty-pgdg" is specific to Ubuntu 14.04 or Mint 17.x
    ### Refer to Postgres website for the proper URL for your distro version
    sudo echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list.d/pgdg.list

    ### Adds the public PGP key to the apt-keys
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

    ### Refresh package list and install Postgres
    sudo apt-get update
    sudo apt-get install postgresql-9.4 libpq-dev

    ### Sudo as the posgres user (to add new role)
    sudo -i -u postgres

    ### Create a new role interactively
    ### Recommended: Use the name of your user
    createuser --interactive

    ### Exit out of postgres (sudo) user
    exit

    ### Edit the Postgres username and password
    nano <path to project>/config/database.yml
    ```

3. Install [ElasticSearch](https://www.elastic.co/downloads/elasticsearch)

    ```
    ### Java 7+ must be installed before installing ElasticSearch

    ### Download the Debian package for ElasticSearch
    wget https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.3.1/elasticsearch-2.3.1.deb

    ### Install using the dpkg command
    ### ElasticSearch is installed in /usr/share/elasticsearch/
    ### Configurations in /etc/elasticsearch
    ### Init script in /etc/init.d/
    sudo dpkg -i elasticsearch-2.3.1.deb

    ### Add the init scripts
    sudo update-rc.d elasticsearch defaults

    ### Start ElasticSearch as a service
    sudo service elasticsearch start
    ```

4. Run the server

    ```
    ### Switch to project directory
    cd <path to project>

    ### Use bundle to install gems
    bundle install

    ### Setup Postgres database
    rake db:setup

    ### Start rails on port 3001
    rails s puma -p 3001
    ```
