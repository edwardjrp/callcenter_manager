# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :coupon do
    code "MyString"
    description "MyText"
    custom_description "MyText"
    generated_description "MyText"
    minimum_price "MyString"
    hidden ""
    secure false
    effective_days "MyString"
    order_sources "MyString"
    service_methods "MyString"
    expiration_date "2012-09-11"
    effective_date "2012-09-11"
    enable false
    discontinued false
  end
end
