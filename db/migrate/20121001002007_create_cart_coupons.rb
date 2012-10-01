class CreateCartCoupons < ActiveRecord::Migration
  def change
    create_table :cart_coupons do |t|
      t.integer :cart_id
      t.integer :coupon_id
      t.string :code
      t.string :target_products

      t.timestamps
    end

    add_column :coupons, :target_products, :string
  end
end
