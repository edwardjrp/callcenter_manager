# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cart_product do
    association(:cart)
    association(:product)
    quantity { rand(99) }
  end
end
