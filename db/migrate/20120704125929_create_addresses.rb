class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer :client_id
      t.integer :street_id
      t.string :number
      t.string :unit_type
      t.string :unit_number
      t.string :postal_code
      t.text :delivery_instructions

      t.timestamps
    end
  end
end
