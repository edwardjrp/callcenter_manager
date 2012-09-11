# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :import_event do
    import_log_id "MyString"
    name "MyString"
    subject "MyString"
    message "MyString"
  end
end
