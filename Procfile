web: bundle exec puma -C config/puma.rb
log: tail -f log/development.log
worker: bundle exec sidekiq -q default -q mailers
