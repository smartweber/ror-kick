FactoryGirl.define do
  factory :order, class: 'Order' do
    status ""
    events_user nil
    payment nil
    stripe_customer_id "MyString"
  end
end
