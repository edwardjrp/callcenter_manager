# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    name "MyString"
    has_options false
    type_unit false
    multi false
    hidden false
    base_product 1
  end
end
