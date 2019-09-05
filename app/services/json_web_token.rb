require 'jwt'

class JsonWebToken
  def self.encode(payload, expiration = 30.days.from_now)
    payload = payload.dup
    payload['exp'] = expiration.to_i
    payload['iat'] = (Time.now.to_f * 1000).to_i
    JWT.encode(payload, Rails.application.secrets.json_web_token_secret)
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.secrets.json_web_token_secret)
  end
end
