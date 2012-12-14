class AddCoockingInstructionsToCartProducts < ActiveRecord::Migration
  def change
    add_column :cart_products, :coocking_instructions, :string
  end
end
