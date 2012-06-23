# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:username) {|u| "#{Faker::Internet.email}_#{u}"}
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
    role_mask {rand(99)}
    password 'please'
    password_confirmation 'please'
    last_action_at "2012-06-23 15:08:47"
    login_count {rand(99)}
    idnumber {11.times.map{ Random.new.rand(9) }.join}
    active false
  end
end
