# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:username) {|u| "a#{u}_#{Faker::Internet.email}"}
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
    roles ['operator']
    password 'please'
    password_confirmation 'please'
    last_action_at "2012-06-23 15:08:47"
    login_count {rand(99)}
    idnumber {11.times.map{ Random.new.rand(9) }.join}
    active true

    trait :admin do
      role_mask 1
    end

    trait :operator do
      role_mask 2
    end
  end
end
