Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  ENV["BASE_URL"] = 'https://test.kickparty.com'
  ENV["DOWNLOAD_URL"] = 'https://testdownload.kickparty.com'


  config.paperclip_defaults = {
    :storage => :s3,
    :s3_region => ENV['AWS_REGION'],
    :s3_protocol => 'https',
    :s3_credentials => {
      :bucket => ENV['S3_BUCKET_NAME'],
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    }
  }

  config.action_mailer.default_url_options = { :host => 'testapi.kickparty.com' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default :charset => "utf-8"

  ActionMailer::Base.smtp_settings = {
    :address => "smtp.sendgrid.net",
    :port => "587",
    :authentication => :plain,
    :domain => 'heroku.com',
    :user_name => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD'],
    :enable_starttls_auto => true
  }

  Rails.application.config.middleware.use ExceptionNotification::Rack,
  :slack => {
  :webhook_url => "https://hooks.slack.com/services/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",
  :channel => "#kp-errors",
    :additional_parameters => {
    :mrkdwn => true
    }
  }

  config.middleware.insert_after(ActionDispatch::Callbacks, ActionDispatch::Cookies)
  config.middleware.insert_after(ActionDispatch::Cookies, ActionDispatch::Session::CookieStore)

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => 'public, max-age=3600'
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  # config.action_mailer.delivery_method = :test

  # Randomize the order test cases are executed.
  config.active_support.test_order = :random

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
end
