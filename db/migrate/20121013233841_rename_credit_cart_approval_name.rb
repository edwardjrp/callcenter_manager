class RenameCreditCartApprovalName < ActiveRecord::Migration
  def up
    rename_column :carts, :credit_cart_approval_name, :credit_cart_approval_number
  end

  def down
    rename_column :carts, :credit_cart_approval_number, :credit_cart_approval_name
  end
end
