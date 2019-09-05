class Api::AttendeesController <  Api::BaseController

  skip_before_action :authenticate_user_from_token!, only: [:index]

  def attend
    event = Event.friendly.find(params[:event_id])
    user_id = @current_user.id
    status = params[:status] || 1

    if EventsUser.exists?(user_id: @current_user.id, event_id: event.id)
      render_error("This user is already attending this event", 400)
    else

      begin
        tier = event.tiers[0]
        if tier.user_set_price || tier.base_cost_per_attendee == 0
          events_user = EventsUser.new
          events_user.user_id = user_id
          events_user.event_id = event.id
          events_user.status = status
          events_user.relation = 0
          events_user.save!

          if Rails.env.production?
            SendSms.send_sms("+14157809000", "New FREE Attendee! #{@current_user.first_name} #{@current_user.last_name} is going to #{event.name}: " + event.short_url_link)
            if event.id == 1
              SendSms.send_sms("+13104672160", "New FREE Attendee! #{@current_user.first_name} #{@current_user.last_name} is going to #{event.name}: " + event.short_url_link)
            end
          end
        else
          render_error("This event requires an order to be placed to secure credit card funds", 400)
        end

      rescue ActiveRecord::RecordInvalid => ex
        render_errors ex.record, 400
        return
      end
    end
  end

  def create
    @event = Event.friendly.find(params[:event_id])

    tier = Tier.where(event_id: @event.id).first

    @attendee = EventsUser.where(user_id: @current_user.id, event_id: @event.id)

    begin
      ActiveRecord::Base.transaction do
        if @attendee.empty?
          @attendee = EventsUser.new
          @attendee.user_id = @current_user.id
          @attendee.event_id = @event.id
          @attendee.status = 1
          @attendee.relation = 0
          @attendee.save!

          payment_id = params[:payment_id]
          @payment = Payment.find(payment_id)

          # Create User, EventUser, and send email for each guest
          guests = params[:guests].present? ? params[:guests] : []
          guests.each do |guest|
            # If guest wasn't found, create an account for him/her
            guest_user = User.find_by_email(guest[:email])
            if !guest_user
              temp_password = SecureRandom.hex(4) # 4 bytes or 8 characters long
              guest_user = User.new({
                email: guest[:email],
                first_name: guest[:first_name],
                last_name: guest[:last_name],
                password: temp_password
              })
              guest_user.save!

              # Send guest welcome email
              WelcomeMailer.welcome_email(guest_user, guest_user, true, temp_password).deliver_later
            end

            # Attend event
            if EventsUser.exists?(user_id: guest_user.id, event_id: @event.id)
              raise StandardError, "Your guest #{guest_user[:first_name]} is already attending this event"
            else
              guest_attendee = EventsUser.new
              guest_attendee.user_id = guest_user.id
              guest_attendee.event_id = @event.id
              guest_attendee.status = 1 # ??
              guest_attendee.relation = 0 # ??
              guest_attendee.save!
              OrderGuestMailer.order_guest_email(guest_user, @event).deliver_later
            end
          end

          @order = Order.new
          @order.status = 0
          @order.payment_id = payment_id
          @order.events_user_id = @attendee.id
          @order.stripe_customer_id = @payment.stripe_customer_id
          @order.contribution_note = params[:note].present? ? params[:note] : nil
          @order.save!

          contribution = params[:contribution].to_f

          if tier.user_set_price
            final_base_cost_per_attendee = (params[:contribution].present? ? contribution : tier.base_cost_per_attendee)
            final_service_charge_per_attendee = Tier.calc_service_charge_per_attendee(final_base_cost_per_attendee)
          else
            final_base_cost_per_attendee = tier.base_cost_per_attendee
            final_service_charge_per_attendee = Tier.calc_service_charge_per_attendee(params[:contribution].present? ? final_base_cost_per_attendee + contribution : final_base_cost_per_attendee)
            final_service_charge_per_attendee += (guests.length * Tier.calc_service_charge_per_attendee(final_base_cost_per_attendee))
          end

          order_items = [
            {order_id: @order.id, cost: final_base_cost_per_attendee, item_type: 1, description: @event.name},
            {order_id: @order.id, cost: final_service_charge_per_attendee, item_type: 2, description: "KickParty processing fee"}
          ]
          if !tier.user_set_price && params[:contribution].present? && contribution > 0
            order_items << {order_id: @order.id, cost: contribution, item_type: 3, description: "Your extra contribution to the event!"}
          end

          # Add an order item for each of the guests
          # Note: Adds an order item even if its free
          guests.each do |guest|
            order_items << {
              order_id: @order.id,
              cost: tier.base_cost_per_attendee,
              item_type: 4, # ??
              description: "Guest - #{guest[:first_name]} #{guest[:last_name]}"
            }
          end
          OrderItem.create!(order_items)

           attendee_count = @event.committed_count
           puts "Attendee Count: #{attendee_count}"
           tier = nil
           if @event.tiers && @event.tiers.length > 0
             tier = @event.tiers[0]
            #  tier.kicked = true
            #  tier.save!
            #  if attendee_count == tier.min_attendee_count
            #     # Kick this party!
            #     SlackNotify.notification("Party kicked! #{@event.name} -- #{@event.short_url_link}")
            #     # Charge cards
            #     @event.events_users.each do |eu|
            #         # only need to charge attendees, not the owner
            #         puts "eu: #{eu.inspect}"
            #         next if eu.relation == 1 # host
            #         u = eu.user
            #         p u
            #         o = eu.order
            #         p o
            #         oitems = o.order_items
            #         # amount to charge is the sum of all order_items
            #         amount = 0.0
            #         oitems.each do |oi|
            #             amount += oi.cost
            #         end
            #         data = {
            #             :amount => (amount * 100.0).to_i,
            #             :customer => o.stripe_customer_id,
            #             :description => "Payment for KickParty: #{@event.name}",
            #             :currency => "USD"
            #         }
            #         puts "About to charge user #{u.id}, $#{amount} for event #{@event.id}"
            #         p data
            #         if amount > 0 # passing zero into stripe throws a crazy error.
            #           charge = Stripe::Charge.create(data)
            #         end
            #     end
             #
            #     # TODO: Send "it kicked" emails?
             #
            #  end
           end


        end
      end

      if Rails.env.production?
        SlackNotify.notification("New Attendee! #{@current_user.first_name} #{@current_user.last_name} is going to #{@event.name}: #{@event.short_url_link}")
        SendSms.send_sms("+14157809000", "New Attendee! #{@current_user.first_name} #{@current_user.last_name} is going to #{@event.name}: " + @event.short_url_link)
      end

      OrderMailer.order_email(@current_user, @order, @event, @payment.payment_type, @payment.number).deliver_later

      @to_user = @event.user
      OrderNotifyMailer.order_notify_email(@current_user, @order, @event, @payment.payment_type, @payment.number, @to_user).deliver_later

      @hosts = User.joins("LEFT OUTER JOIN events_users AS hosts ON users.id = hosts.user_id")
        .where("hosts.relation = 1 AND hosts.event_id = ? AND hosts.user_id != ?", @event.id, @event.user.id)
        .distinct

      @hosts.each do |h|
        @to_user = h
        OrderNotifyMailer.order_notify_email(@current_user, @order, @event, @payment.payment_type, @payment.number, @to_user).deliver_later
      end
    rescue ActiveRecord::RecordInvalid => ex
      render_errors ex.record, 400
      return
    rescue StandardError => error
      render_error error.message, 400
      return
    end
  end

  def index
    @current_user = get_user!

    event = Event.friendly.find(params[:id])
    limit = params['limit'] || nil
    offset = params['offset'] || 0

    @attendees = event.attendee_list(limit, offset)

    if(@current_user.present?)
      followed_offset = params[:followed_offset] || 0
      followed_limit = params[:followed_limit] || 20
      id = @current_user.id
      @followed = Relationship.includes(:followed)
        .where(follower: id)
        .offset(followed_offset)
        .limit(followed_limit)
    end
  end

  def update_relation

    event = Event.friendly.find(params[:event_id])

    if event.isHost( @current_user.id )
      p "You are a host"
    end

    @status = false
    if params[:add]
      status = EventsUser.where( user_id: params[:user_id] ).where( event_id: event.id).update_all( relation: 1 )
    else
      status = EventsUser.where( user_id: params[:user_id] ).where( event_id: event.id).update_all( relation: 0 )
    end

    if status >= 1
      @status = true
    end
  end

  def patch
  end

  def destroy
    # TODO: Add much more processing to this: 1) Event not kicked, 2) deal with order, etc.
    event = Event.friendly.find(params[:id])

    attendee = EventsUser.where(user_id: @current_user.id, event_id: event.id).first

    if !attendee.blank?
      begin
        ActiveRecord::Base.transaction do
          order_count = Order.where(events_user_id: attendee.id).count

          if order_count > 1 # This should NEVER happen, so throw ex
            throw "Multiple orders cannot be deleted."
          elsif order_count == 1
            order = Order.where(events_user_id: attendee.id).first
            order_items = OrderItem.where(order_id: order.id).destroy_all
            order.destroy!
          end

          attendee.destroy! unless event.created_by == @current_user.id
        end

        rescue ActiveRecord::RecordInvalid => ex
          render_errors ex.record, 400
          return
      end
    end
  end

  def export
    event = Event.friendly.find(params[:id])
    current_user = get_user!
    if event && event.isHost(current_user)
      @attendees = event.attendee_list
      @orders = EventsUser.users_orders(event.id)
    else
      head :unauthorized
    end
  end

  private

  def attendee_params
    params.permit(:event_id)
  end
end
