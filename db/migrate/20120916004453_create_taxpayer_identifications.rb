class CreateTaxpayerIdentifications < ActiveRecord::Migration
  def change
    create_table :taxpayer_identifications do |t|
      t.string :idnumber
      t.string :full_name
      t.string :company_name
      t.string :ocupation
      t.string :street
      t.string :street_number
      t.string :zone
      t.string :other
      t.string :start_time
      t.string :state
      t.string :kind
    end

    add_index :taxpayer_identifications, :idnumber, unique: true
  end
end
