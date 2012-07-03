# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :store do
    name {Faker::Name.first_name}
    address {Faker::Lorem.sentence}
    ip {[rand(255).to_s, rand(255).to_s, rand(255).to_s, rand(255).to_s].join('.')}
    association :city
    storeid {rand(1500)}
  end
end
