# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :taxpayer_identification do
    sequence(:idnumber) { |tid| "87687#{tid}" }
    sequence(:full_name) { |tid| "tax_id_#{tid}"}
    company_name { Faker::Lorem.words }
    ocupation { Faker::Lorem.words }
    street { Faker::Lorem.words }
    street_number { Faker::Lorem.words }
    zone { Faker::Lorem.words }
    other { Faker::Lorem.words }
    start_time { Faker::Lorem.words }
    state { Faker::Lorem.words }
    kind { Faker::Lorem.words }
  end
end
