# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    name "MyString"
    has_options false
    unit_type "MyString"
    multi false
    hidden false
    base_product 1
    flavor_code_src "MyString"
    flavor_code_dst "MyString"
    size_code_src "MyString"
    size_code_dst "MyString"
  end
end
