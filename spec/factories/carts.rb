# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cart do
    association(:user)
    association(:client)
    association(:store)
    association(:reason)
    service_method 'dinein'

    after(:build) do |cart|
      cart.client.phones << create(:phone) unless cart.client.nil?
    end
  end
end
