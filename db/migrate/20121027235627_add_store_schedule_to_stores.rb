class AddStoreScheduleToStores < ActiveRecord::Migration
  def change
    add_column :stores, :store_schedule, :text
  end
end
