class CreateUserCarts < ActiveRecord::Migration
  def change
    create_table :user_carts do |t|
      t.integer :user_id
      t.integer :cart_id

      t.timestamps
    end
  end
end
