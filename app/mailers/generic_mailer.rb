class GenericMailer < ApplicationMailer
  default from: "KickParty <#{ENV["EMAIL_ACCOUNT"]}>"

  def generic_email(user, text, subject, from=nil, reply_to=nil, email_id=nil, show_events=false)

    @user = user
    @to_user = user
    @text = text
    @subject = subject
    @show_events = show_events
    @email_id = email_id
    @tracker_url = "#{ENV["DOWNLOAD_URL"]}/images/#{@email_id}/kickparty-email.png" if @email_id

    if @show_events
      where_clause = {
        start: {gt: Time.now},
        status: 1
      }
      order_by = {
        _score: :desc,
        deadline: :asc
      }
      @events = Event.search "*", where: where_clause, limit: 6, order: order_by
    end

    to = @user.first_name.present? && @user.last_name.present? ? "#{@user.first_name} #{@user.last_name} <#{@user.email}>" : @user.email

    if from.present?
      mail(from: from, reply_to: reply_to, to: to, subject: @subject)
    else
      mail(to: to, subject: @subject)
    end

  end
end
