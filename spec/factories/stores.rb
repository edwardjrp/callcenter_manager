# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :store do
    sequence(:name) { |n| "Store name #{n}"}
    address {Faker::Lorem.sentence}
    ip {[rand(255).to_s, rand(255).to_s, rand(255).to_s, rand(255).to_s].join('.')}
    association :city
    sequence(:storeid, 1000) { | n |  n }
  end
end
