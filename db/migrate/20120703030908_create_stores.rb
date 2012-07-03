class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.string :address
      t.string :ip
      t.integer :city_id
      t.integer :storeid

      t.timestamps
    end
  end
end
