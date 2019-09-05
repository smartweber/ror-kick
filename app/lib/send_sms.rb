class SendSms
  require 'rubygems'
  require 'twilio-ruby'

  def self.send_sms(to, body)
    client = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN']
    )
    client.messages.create(
      to: to,
      from: ENV['TWILIO_FROM_NUMBER'],
      body: body
    )
  end
end
