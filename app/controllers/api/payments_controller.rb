class Api::PaymentsController < Api::BaseController
  def create

    card_number =  payment_params[:number]
    last_four = card_number[-4..-1] || card_number
    payment_type = card_number[0].to_i # 4:Visa, 5:MC, 6:Discover, 3:Amex

    data = {
      "description": payment_params[:name],
      "email": payment_params[:email],
      "source": {
        "object": "card",
        "exp_month": payment_params[:exp_month],
        "exp_year": payment_params[:exp_year],
        "number": card_number,
        "cvc": payment_params[:cvc],
        "address_line1": payment_params[:line1],
        "address_zip": payment_params[:postal_code],
        "name": payment_params[:name]
      }
    }

    begin
      customer = Stripe::Customer.create(
        data
      )

      if payment_params[:default]
        @current_user.stripe_customer_id = customer.id
        @current_user.save
        Payment.where(user_id: @current_user.id).update_all(:default => false)
      end

      @payment = Payment.new
      @payment.stripe_customer_id = customer.id
      @payment.default = payment_params[:default]
      @payment.payment_type = payment_type
      @payment.exp_month = payment_params[:exp_month]
      @payment.exp_year = payment_params[:exp_year]
      @payment.number = last_four
      @payment.address_line1 = payment_params[:line1]
      @payment.address_zip = payment_params[:postal_code]
      @payment.name = payment_params[:name]
      @payment.nick_name = payment_params[:nick_name]
      @payment.user_id = @current_user.id

      return unless save(@payment)

    rescue Stripe::CardError => ex
      # this happens every time with non test card:
      # #<Stripe::CardError: (Status 402) (Request req_7xNt8utedLN4qC) Your card was declined. Your request was in test mode, but used a non test card. For a list of valid test cards, visit: https://stripe.com/docs/testing.>
      puts "Stripe error #{ex}"
      render_error("Card error: #{ex.message}")
      return
    end
  end

  def index
    @payments = Payment.where(user_id: @current_user.id)
  end

  def show
    @payment = Payment.where(user_id: @current_user.id).where(id: params[:id]).first
  end

  def default
    @payment = Payment.where(user_id: @current_user.id).where(default: true).first
  end

  def destroy
    payment_count = Payment.where(user_id: @current_user.id).count

    if payment_count == 1 # User may only delete the default payment method if it's the only one.
      payment = Payment.where(user_id: @current_user.id).where(id: params[:id]).first
    else
      payment = Payment.where(user_id: @current_user.id).where(id: params[:id]).where.not(default: true).first
    end

    return unless destroy_obj(payment)
  end

  def update_default
    begin
      ActiveRecord::Base.transaction do
        Payment.where(user_id: @current_user.id).update_all(:default => false)

        payment = Payment.where(id: payment_params[:id])
                .where(user_id: @current_user.id)
                .first

        payment.update_attribute(:default, true)

        @current_user.stripe_customer_id = payment.stripe_customer_id
        return unless save(@current_user)
      end
    rescue ActiveRecord::RecordInvalid => ex
      render_errors ex.record, 400
      return
    end
  end

  private

  def payment_params
    params.permit(:id, :nick_name, :default, :name, :email, :exp_month, :exp_year, :number, :cvc, :line1, :postal_code)
  end

end
