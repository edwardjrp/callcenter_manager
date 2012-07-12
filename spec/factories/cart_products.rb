# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cart_product do
    cart_id 1
    quantity "9.99"
    product_id 1
    bind_id 1
    options "MyString"
  end
end
