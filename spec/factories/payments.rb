FactoryGirl.define do
  factory :payment do
    stripe_customer_id "MyString"
    payment_type 1
    number "MyString"
    exp_month 1
    exp_year 1
    address_line1 "MyString"
    address_zip "MyString"
    name "MyString"
    user nil
  end
end
