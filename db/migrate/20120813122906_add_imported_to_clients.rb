class AddImportedToClients < ActiveRecord::Migration
  def change
    add_column :clients, :imported, :boolean, :default=> false
    add_column :carts, :message_mask, :integer
  end
end
