class CreateCartProducts < ActiveRecord::Migration
  def change
    create_table :cart_products do |t|
      t.integer :cart_id
      t.decimal :quantity
      t.integer :product_id
      t.integer :bind_id
      t.string :options

      t.timestamps
    end
  end
end
