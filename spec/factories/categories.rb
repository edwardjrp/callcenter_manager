# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    sequence(:name){|c| "test_category_#{c}"}
    has_options false
    type_unit false
    multi false
    hidden false
  end
end
