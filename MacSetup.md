# Mac Install
1. Install [Homebrew](http://brew.sh), [Ruby](https://www.ruby-lang.org/en/), and [Rails](http://rubyonrails.org/) using the guide
    ```
    ### Install Homebrew
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    ### When asked you to install XCode CommandLine Tools, say yes.

    ### Install rbenv to intall and manage Ruby versions
    brew install rbenv ruby-build

    ### Install Ruby v2.3.0 with Homebrew
    rbenv install 2.3.0
    rbenv global 2.3.0
    ruby -v

    ### Install Rails v4.2.6 with gem
    gem install rails -v 4.2.6

    ### We need rbenv to see the rails executable
    rbenv rehash
    rails -v
    ```
2. Install [Postgres 9.5 for Mac](http://www.postgresql.org/download/macosx/)
    ```
    ### Download and Install Postgres.app at http://postgresapp.com
    ### Run the application to start a PostgresSQL server running locally
    ```
3. Install [ElasticSearch](https://www.elastic.co/downloads/elasticsearch)
    ```
    ### Install ElasticSearch using Homebrew
    brew install elasticsearch

    ### Start ElasticSearch
    elasticsearch
    ```
4. Run the server
    ```
    ### Switch to project directory
    cd <path to project>

    ### Use bundle to install gems
    bundle install

    ### Start rails on port 3001
    rails s puma -p 3001
    ```
