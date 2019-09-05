FactoryGirl.define do
  factory :order_item do
    cost "9.99"
    description "MyString"
    order nil
  end
end
