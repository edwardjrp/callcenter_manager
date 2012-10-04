class ChangeTypeCouponProducts < ActiveRecord::Migration
  def up
    change_column :coupons, :target_products, :text
    change_column :cart_coupons, :target_products, :text
  end

  def down
    change_column :coupons, :target_products, :string
    change_column :cart_coupons, :target_products, :string
  end
end
