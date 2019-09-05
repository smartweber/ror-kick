class SlackNotify
  require 'slack-notifier'

  def self.notification(message, channel="#kp-notifications")
    notifier = Slack::Notifier.new "https://hooks.slack.com/services/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"
    notifier.channel = channel
    notifier.ping message
  end
end
