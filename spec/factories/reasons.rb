# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reason do
    sequence(:description) { |r| "reason_#{r}" }
  end
end
