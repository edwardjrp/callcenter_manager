# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    association(:category)
    productcode {['14SCREEN', '12SCREEN', '10SCREEN'].shuffle.first}
    productname {Faker::Name.first_name}
    options {['O', 'C', 'X'].shuffle.first}    
    sizecode {['14', '12', '10'].shuffle.first} 
    flavorcode  {['THIN', 'DEEPDISH', 'HANDTOSS'].shuffle.first} 
  end
end
