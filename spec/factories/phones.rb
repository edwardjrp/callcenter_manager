# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :phone do
    number {Faker::PhoneNumber.phone_number}
    ext {rand(99).to_s}
    association(:client)
  end
end
