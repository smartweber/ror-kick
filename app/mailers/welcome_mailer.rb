class WelcomeMailer < ApplicationMailer
  default from: "KickParty <#{ENV["EMAIL_ACCOUNT"]}>"

  def welcome_email(user, to_user, is_guest_email = false, temp_password)

    @user = user
    @to_user = to_user
    @is_guest_email = is_guest_email
    @temp_password = temp_password

    where_clause = {
      start: {gt: Time.now},
      status: 1
    }
    order_by = {
      _score: :desc,
      deadline: :asc
    }
    @events = Event.search "*", where: where_clause, limit: 6, order: order_by

    @to_user = @user #this always has to be set for the template wrapper
    mail(to: "#{@user.first_name} #{@user.last_name} <#{@user.email}>", subject: "Welcome to KickParty!")
  end
end
