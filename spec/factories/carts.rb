# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cart do
    association(:user)
    association(:client)
    association(:store)
    service_method 'dinein'
    payment_amount { rand(1000) + 20 }
    sequence(:store_order_id) {|n| "2012-10-18##{n}"}

    after(:build) do |cart|
      cart.client.phones << create(:phone) unless cart.client.nil?
    end

    trait :with_reason do
      after(:create) do |instance|
        reason = factory :reason
      end
    end
  end
end
