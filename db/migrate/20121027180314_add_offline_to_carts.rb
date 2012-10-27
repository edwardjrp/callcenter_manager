class AddOfflineToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :offline, :boolean, default: false
    add_column :carts, :communication_failed_on, :datetime
  end
end
