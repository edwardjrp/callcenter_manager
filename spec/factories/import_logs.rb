# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :import_log do
    log_type "MyString"
    state "MyString"
  end
end
