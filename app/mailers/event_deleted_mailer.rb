class EventDeletedMailer < ApplicationMailer
  default from: "KickParty <#{ENV["EMAIL_ACCOUNT"]}>"

  def event_delete(to_user, event)

    @to_user = to_user
    @event = event

    mail(to: "#{@to_user.first_name} #{@to_user.last_name} <#{@to_user.email}>",
      subject: "\"#{@event.name}\" has been cancelled")

  end
end
