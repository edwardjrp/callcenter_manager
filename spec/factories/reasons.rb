# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reason do
    sequence(:content) { |r| "reason_#{r}" }
  end
end
