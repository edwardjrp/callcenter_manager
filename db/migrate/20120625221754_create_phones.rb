class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :number
      t.string :ext
      t.integer :client_id

      t.timestamps
    end
    
    add_index :phones, :number
    add_index :phones, :client_id
  end
end
