class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :idnumber
      t.integer :target_address_id
      t.integer :target_phone_id
      t.integer :phones_count
      t.integer :addresses_count
      t.boolean :active

      t.timestamps
    end
    
    add_index :clients, :idnumber, :unique=>true
    add_index :clients, :email, :unique=>true  
  end
end
