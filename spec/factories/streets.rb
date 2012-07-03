# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :street do
    name {Faker::Address.street}
    association :area
  end
end
