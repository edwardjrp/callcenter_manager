namespace :tax_number do

  desc "update TaxNumber with valids in pulse"
  task :update_to_pulse => :environment do
    TaxNumber.update_all({fiscal_type: 'SpecialRegime'}, { fiscal_type: 'SpecialRegme'})
  end

end