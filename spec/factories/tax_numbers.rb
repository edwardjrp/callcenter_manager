# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tax_number do
    secquence(:rnc) { |tn| "1234#{tn}" }
    verified false
    association(:client)
  end
end
