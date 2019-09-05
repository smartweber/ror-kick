# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
# Strings added here are treated as Regular Expressions
# Ex: 'password' will block 'password' and 'password_confirmation'
Rails.application.config.filter_parameters += [:password]
