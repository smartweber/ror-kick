class ContactMailer < ApplicationMailer
  # default from: "KickParty <#{ENV["EMAIL_ACCOUNT"]}>"

  def contact_email(text, subject, from, phone, email, reply_to)

    @text = text
    @subject = subject
    @from = from
    @phone = phone
    @email = email
    @reply_to = reply_to
    #@email_id = email_id
    #@tracker_url = "#{ENV["DOWNLOAD_URL"]}/images/#{@email_id}/kickparty-email.png" if @email_id

    to = "info@kickparty.com"
    reply_to = email

    # if from.present?
    mail(from: from, reply_to: reply_to, to: to, subject: subject)
    # else
    #   mail(to: to, subject: @subject)
    # end

  end
end
