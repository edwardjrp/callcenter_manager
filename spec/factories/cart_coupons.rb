# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cart_coupon do
    cart_id 1
    coupon_id 1
    code "MyString"
    target_products "MyString"
  end
end
