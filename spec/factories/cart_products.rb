# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cart_product do
    association(:cart)
    association(:product)
    priced_at { rand(100) + 1 }
    quantity { rand(99) }
  end
end
