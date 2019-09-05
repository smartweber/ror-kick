class Api::EmailsController < Api::BaseController
  skip_before_action :authenticate_user_from_token!, only: [:mark_read, :contact_email]

  def create
    event = Event.friendly.find(params[:id])

    if event && event.isHost(@current_user.id) # TODO: add check for owner or host
      subject = params[:subject]
      body = params[:body]
      email = Email.new
      email.event_id = event.id
      email.subject = subject
      email.body = body
      email.created_by = @current_user.id
      email.save!

      if params[:send_preview].present? & params[:send_preview]
        from = "#{@current_user.first_name} #{@current_user.last_name} via KickParty <#{ENV["EMAIL_ACCOUNT"]}>"
        reply_to = "#{@current_user.first_name} #{@current_user.last_name} <#{@current_user.email}>"
        GenericMailer.generic_email(@current_user, email.body, email.subject, from, reply_to).deliver_later
      else
        EventMailJob.perform_later(email.id, subject, body, @current_user)
      end
    else
      render_error("You are not authorized to send an email to this group.", 401)
    end
  rescue ActiveRecord::RecordNotFound => e
    head :not_found
  end

  def contact_email
    p "***params***"
    p params

      subject = "New contact message from " + params[:name]
      message = params[:message]

      email = Email.new
      email.subject = subject
      email.body = message
      email.save!

      from = params[:name]
      reply_to = params[:email]
      ContactMailer.contact_email(email.body, email.subject, from, params[:phone], reply_to).deliver_later
      #EventMailJob.perform_later(email.id, subject, body, params[:from])

  rescue ActiveRecord::RecordNotFound => e
    head :not_found
  end

  def mark_read
    img = 'https://s3-us-west-1.amazonaws.com/kickparty-public/email/pixel.png'
    id = params[:id]
    if id.present?
      EmailsUser.where(id: id).where(read: nil).update_all({:read => DateTime.now})
    end
    redirect_to img
  rescue ActiveRecord::RecordNotFound => e
    redirect_to img
  end

end
