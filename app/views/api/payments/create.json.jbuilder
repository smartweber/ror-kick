json.key_format! camelize: :lower

json.data do
  if @payment
    json.id @payment.id
    json.default @payment.default
    json.payment_type @payment.payment_type
    json.exp_month @payment.exp_month
    json.exp_year @payment.exp_year
    json.number @payment.number
    json.address_line1 @payment.address_line1
    json.address_zip @payment.address_zip
    json.name @payment.name
    json.nick_name @payment.nick_name
  end
end
json.response do
  json.code 201
end
