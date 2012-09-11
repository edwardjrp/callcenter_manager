class AddVersionsToDeprecables < ActiveRecord::Migration
  def change
    add_column :products, :discontinued, :boolean, default: false
    add_column :stores, :discontinued, :boolean, default: false
  end
end
