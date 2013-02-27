# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :report do
    name %W( Detallado Consolidado Cupones Descuentos ProductsMix PorHora ).sample
    csv_file { File.open(Rails.root + 'spec/fixtures/consolidado.csv') }
    pdf_file { File.open(Rails.root + 'spec/fixtures/consolidado.pdf') }
  end
end