FactoryGirl.define do
  factory :email do
    from "MyString"
    user nil
    to "MyString"
    to_name "MyString"
    subject "MyString"
    body "MyString"
    sent false
    read false
    created_by 1
  end
end
