source 'https://rubygems.org'
ruby '2.3.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0'
gem 'activesupport', '~> 5.0.0'

# Replace with '>=0.10.0' when released: https://github.com/rails-api/active_model_serializers
# gem 'active_model_serializers', github: 'rails-api/active_model_serializers'

gem 'rack-cors', :require => 'rack/cors'
gem 'devise', github: 'plataformatec/devise'
gem 'omniauth', '~> 1.9'
gem 'paperclip', github: 'thoughtbot/paperclip'
gem 'aws-sdk', '>= 2.0.0'
gem 'stripe'
gem 'friendly_id', '~> 5.1.0'
gem 'underscore_params', '~> 0.0.2'
gem 'jwt'
gem 'jbuilder'
gem 'kaminari'
gem 'responders'
gem 'oauth2', github: 'intridea/oauth2'
gem 'omniauth-facebook', '~> 4.0.0.rc1'
gem 'pg'
gem 'pry'
gem 'mini_fb'
gem 'searchkick'
gem "elasticsearch", ">= 1.0.15"
gem 'faraday_middleware-aws-signers-v4'
gem 'icalendar'
gem 'sendgrid-ruby'
gem 'newrelic_rpm'
gem 'twilio-ruby'
gem 'shortener'
gem 'exception_notification'
gem 'slack-notifier'
gem 'sidekiq'

# Use Puma as the app server
gem 'puma'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'ffaker'
end

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
