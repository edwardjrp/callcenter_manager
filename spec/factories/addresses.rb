# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    association(:client)
    association(:street)
    sequence(:number){|n| "A#{n}"}
    unit_type {%w( Oficina Casa Edificio).shuffle.first}
    sequence(:unit_number){|n| "A#{n}"}
    sequence(:postal_code){|n| "1020#{n}"}
    delivery_instructions {Faker::Lorem.sentence}
  end
end
