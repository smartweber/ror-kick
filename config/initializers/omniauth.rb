Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, Rails.application.secrets.facebook_key, Rails.application.secrets.facebook_secret, scope: 'email', info_fields: 'email'
end
