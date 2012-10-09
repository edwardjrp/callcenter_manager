class CreateTaxNumbers < ActiveRecord::Migration
  def change
    create_table :tax_numbers do |t|
      t.string :rnc
      t.boolean :verified, :default=> false
      t.integer :client_id

      t.timestamps
    end

    add_index :tax_numbers, :client_id
  end
end
