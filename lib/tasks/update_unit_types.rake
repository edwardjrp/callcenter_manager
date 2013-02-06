namespace :unit_type do

  desc "update unit types with valids in pulse"
  task :update_to_pulse => :environment do
    Address.update_all({unit_type: 'Apartment'}, { unit_type: 'edificio'})
    Address.update_all({unit_type: nil }, { unit_type: 'Casa'})
    Address.update_all({unit_type: nil }, { unit_type: 'casa'})
    Address.update_all({unit_type: 'Office'}, { unit_type: 'Oficina'})
    Address.update_all({unit_type: 'Office'}, { unit_type: 'Oficina'})
  end

end