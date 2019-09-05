class EventMailJob < ApplicationJob
  queue_as :default

  def perform(email_id, subject, body, current_user) # *args

    email = Email.find(email_id)
    event = email.event
    from = "#{current_user.first_name} #{current_user.last_name} via KickParty <#{ENV["EMAIL_ACCOUNT"]}>"
    reply_to = "#{current_user.first_name} #{current_user.last_name} <#{current_user.email}>"

    event.users.each do |user|
      email_user = EmailsUser.new
      email_user.user_id = user.id
      email_user.email_id = email.id
      email_user.save!
    end

    email_users = EmailsUser.where(email_id: email.id)
    email_users.each do |email_user|
      if email_user.sent.blank?
        GenericMailer.generic_email(email_user.user, email.body, email.subject, from, reply_to, email_user.id).deliver_later
        email_user.sent = DateTime.now
        email_user.save!
      end
    end
  end
end
