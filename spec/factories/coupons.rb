# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :coupon do
    sequence(:code, 1000) { |c| "RD#{c}"}
    description "MyText"
    custom_description "MyText"
    generated_description "MyText"
    minimum_price { rand(500) + 1 }
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
