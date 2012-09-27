class AddPlacedOnCompletedOnToCart < ActiveRecord::Migration
  def change
    add_column :carts, :complete_on , :datetime
    add_column :carts, :placed_at , :datetime
    add_column :carts, :exonerated , :boolean
  end
end
