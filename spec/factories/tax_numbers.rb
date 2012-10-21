# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tax_number do
    sequence(:rnc) { |tn| "%011d" % tn }
    sequence(:company_name) { |tn| "name#{tn}" }
    verified false
    fiscal_type { ["FinalConsumer","3rdParty","SpecialRegme","Government"].sample }
    association(:client)
  end
end
