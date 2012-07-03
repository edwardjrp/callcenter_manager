# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :area do
    name {Faker::Name.first_name}
    association :city
  end
end
