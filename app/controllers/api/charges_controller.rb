class Api::ChargesController < Api::BaseController

  def failed
    if @current_user.admin
      order = Order.find(params[:id])
      @user = order.order_user
      @text = params[:text]
      @subject = params[:subject]

      GenericMailer.generic_email(@user, @text, @subject).deliver_later
    end
  end

  def create
    order = Order.find(params[:order])

    if order.present? && !order.processed

      begin
        ActiveRecord::Base.transaction do

        amount = order.order_total
        customer = order.stripe_customer_id

        if @current_user.admin && customer.present? && amount.present? && amount > 0
          # Amount in cents
          amount = (amount * 100.0).to_i

          @charge = Stripe::Charge.create(
            :customer    => customer,
            :amount      => amount,
            :description => 'KickParty Event: ' + order.order_event.name,
            :statement_descriptor => 'KickParty: ' + order.order_event.name.first(11),
            :currency    => 'USD'
          )

          order.processed = true
          order.processed_at = DateTime.now
          order.save!

          @order = order
          @event = order.order_event
          @user = order.order_user
          @payment = order.payment

          OrderKickedMailer.order_kicked_email(@user, @order, @event, @payment.payment_type, @payment.number).deliver_later

        end
      end

      rescue ActiveRecord::RecordInvalid => ex
        render_errors ex.record, 400
        return
      end

    end

  rescue Stripe::CardError => ex
    puts "Stripe error #{ex}"
    render_error("Card error: #{ex.message}")
  end

end
