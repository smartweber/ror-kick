class OrderGuestMailer < ApplicationMailer
  default from: "KickParty <#{ENV["EMAIL_ACCOUNT"]}>"

  def order_guest_email(user, event)

    @user = user
    @event = event

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

    @to_user = @user #this always has to be set for the template wrapper
    mail(to: "#{@user.first_name} #{@user.last_name} <#{@user.email}>", subject: "Your Confirmation for #{@event.name}")
  end
end
