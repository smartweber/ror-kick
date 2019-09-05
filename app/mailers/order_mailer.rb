class OrderMailer < ApplicationMailer
  default from: "KickParty <#{ENV["EMAIL_ACCOUNT"]}>"

  def order_email(user, order, event, payment_type, number)

    @user = user
    @order = order
    @event = event
    @number = number

    where_clause = {
      start: {gt: Time.now},
      status: 1,
      id: {not: event.id}
    }
    order_by = {
      _score: :desc,
      deadline: :asc
    }
    @events = Event.search "*", where: where_clause, limit: 6, order: order_by, boost_by_distance: {field: :location, origin: {lat: @event.location_lat, lon: @event.location_lng}}

    @deadline = get_time_in_time_zone( @event.deadline, (@event.timezone_offset/60) )
    @start = get_time_in_time_zone( @event.start, (@event.timezone_offset/60) )
    @order_time = Time.now

    case payment_type
    when 3
      @payment_type = "Amex"
    when 5
      @payment_type = "MasterCard"
    when 6
      @payment_type = "Discover Card"
    else
      @payment_type = "Visa"
    end

    @to_user = @user #this always has to be set for the template wrapper
    mail(to: "#{@user.first_name} #{@user.last_name} <#{@user.email}>", subject: "Your Confirmation for #{@event.name}")
  end
end
