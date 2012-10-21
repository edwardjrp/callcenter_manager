class RenameCreditCartColumnInCarts < ActiveRecord::Migration
  def up
    rename_column :carts, :credit_cart_approval_number, :credit_card_approval_number
  end

  def down
    rename_column :carts, :credit_card_approval_number, :credit_cart_approval_number
  end
end
