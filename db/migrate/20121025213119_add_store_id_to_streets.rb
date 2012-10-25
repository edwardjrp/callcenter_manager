class AddStoreIdToStreets < ActiveRecord::Migration
  def change
    add_column :streets, :store_id, :integer
  end
end
