class Api::CustomersController < Api::BaseController
#######################################
### THIS IS BEING DEPRECATED ###
######################################

  def create

    if !@current_user.stripe_customer_id

      card_number =  customer_params["number"]
      last_four = card_number[-4..-1] || card_number
      payment_type = card_number[0].to_i # 4:Visa, 5:MC, 6:Discover, 3:Amex

      data = {
        "description": customer_params["name"],
        "email": @current_user.email,
        "source": {
          "object": "card",
          "exp_month": customer_params["exp_month"],
          "exp_year": customer_params["exp_year"],
          "number": card_number,
          "cvc": customer_params["cvc"],
          "address_line1": customer_params["line1"],
          "address_zip": customer_params["postal_code"],
          "name": customer_params["name"]
        }
      }

      begin
        customer = Stripe::Customer.create(
          data
        )
        @current_user.stripe_customer_id = customer.id

        payment = Payment.new
        payment.stripe_customer_id = customer.id
        payment.payment_type = payment_type
        payment.exp_month = customer_params["exp_month"]
        payment.exp_year = customer_params["exp_year"]
        payment.number = last_four
        payment.address_line1 = customer_params["line1"]
        payment.address_zip = customer_params["postal_code"]
        payment.name = customer_params["name"]
        payment.user_id = @current_user.id

        payment.save!

        return unless save(@current_user)

      rescue Stripe::CardError => ex
        # this happens every time with non test card:
        # #<Stripe::CardError: (Status 402) (Request req_7xNt8utedLN4qC) Your card was declined. Your request was in test mode, but used a non test card. For a list of valid test cards, visit: https://stripe.com/docs/testing.>
        puts "Stripe error #{ex}"
        render_error("Card error: #{ex.message}")
        return
      end

    end
  end

  private

  def customer_params
    params.permit(:name, :exp_month, :exp_year, :number, :cvc, :line1, :postal_code)
  end
end
