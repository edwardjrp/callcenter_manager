class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :areas, :city_id
    add_index :areas, :store_id
    add_index :addresses, :client_id
    add_index :addresses, :street_id
    add_index :cart_products, :cart_id
    add_index :cart_products, :product_id
    add_index :cart_products, [:cart_id, :product_id]
    add_index :store_products, :store_id
    add_index :store_products, :product_id
    add_index :store_products, [:product_id, :store_id]
    add_index :carts, :reason_id
    add_index :user_carts, :user_id
    add_index :user_carts, :cart_id
    add_index :products, :category_id
    add_index :stores, :city_id
    add_index :import_events, :import_log_id
    add_index :streets, :area_id
    add_index :streets, :store_id
    add_index :cart_coupons, :cart_id
    add_index :cart_coupons, :coupon_id
  end
end
