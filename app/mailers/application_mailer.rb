class ApplicationMailer < ActionMailer::Base
  include TimeHelper
  add_template_helper(TimeHelper)

  default from: ENV["EMAIL_ACCOUNT"]
  layout 'mailer'
end
