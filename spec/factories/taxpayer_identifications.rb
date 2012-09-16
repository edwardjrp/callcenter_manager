# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :taxpayer_identification do
    idnumber "MyString"
    full_name "MyString"
    company_name "MyString"
    ocupation "MyString"
    street "MyString"
    street_number "MyString"
    zone "MyString"
    other "MyString"
    start_time "MyString"
    state "MyString"
    kind "MyString"
  end
end
