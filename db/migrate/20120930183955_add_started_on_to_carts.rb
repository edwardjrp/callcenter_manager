class AddStartedOnToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :started_on, :datetime
  end
end
