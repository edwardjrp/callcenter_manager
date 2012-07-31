class AddPricedAtToCartProduct < ActiveRecord::Migration
  def change
    add_column :cart_products, :priced_at, :decimal
  end
end
