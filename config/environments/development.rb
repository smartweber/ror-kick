Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.

  ENV["ELASTICSEARCH_URL"] ||= "http://localhost:9200"
  ENV['AWS_ACCESS_KEY_ID'] = "AKIAIG3WGGE74NUKB2XA"
  ENV['AWS_SECRET_ACCESS_KEY'] = "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"
  ENV['AWS_REGION'] = "us-west-1"
  ENV['AWS_SEARCH_REGION'] = "us-west-2"

  ENV['REDIS_PROVIDER'] = "http://localhost:6379"

  ENV['TWILIO_ACCOUNT_SID'] = "ACe0c79e37d431c08a779ddc60a62626ed"
  ENV['TWILIO_AUTH_TOKEN'] = "da6333462342497312c7b5fc7950f187"
  ENV['TWILIO_FROM_NUMBER'] = "+15005550006"

  ENV["EMAIL_ACCOUNT"] = 'dev@kickparty.com'
  ENV["EMAIL_PASSWORD"] = 'lAQKsCy1PWyM+olD9bQwBh1ie'

  ENV["BASE_URL"] = 'http://localhost:3000'
  ENV["DOWNLOAD_URL"] = 'http://localhost:3001'

  config.paperclip_defaults = {
    :storage => :s3,
    :s3_region => ENV['AWS_REGION'],
    :s3_credentials => {
      :bucket => "s3-dev.kickparty.com",
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
      :region => ENV['AWS_REGION']
    }
    # , :s3_host_name => "s3.amazonaws.com"
    # , :url => ":s3_domain_url"
  }

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default :charset => "utf-8"

  ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587,
    :authentication => :login,
    :enable_starttls_auto => true,
    :domain => 'gmail.com',
    :user_name => ENV["EMAIL_ACCOUNT"],
    :password => ENV["EMAIL_PASSWORD"]
  }

  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  config.middleware.insert_after(ActiveRecord::Migration::CheckPending, ActionDispatch::Cookies)
  config.middleware.insert_after(ActionDispatch::Cookies, ActionDispatch::Session::CookieStore)

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load


  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  # config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
