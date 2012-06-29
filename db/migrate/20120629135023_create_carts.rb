class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.integer :user_id
      t.integer :client_id
      t.boolean :communication_failed, :default=>false
      t.string :status_text
      t.integer :store_id
      t.string :store_order_id
      t.string :service_method
      t.datetime :business_date
      t.datetime :advance_order_time
      t.decimal :net_amount
      t.decimal :tax_amount
      t.decimal :tax1_amount
      t.decimal :tax2_amount
      t.decimal :payment_amount
      t.string :message 
      t.string :order_text
      t.string :order_progress
      t.boolean :can_place_order
      t.text :delivery_instructions
      t.string :payment_type
      t.string :credit_cart_approval_name
      t.string :fiscal_number
      t.string :fiscal_type
      t.string :company_name
      t.decimal :discount
      t.integer :discount_auth_id
      t.boolean :completed
      t.timestamps
    end
    
    add_index :carts, :user_id    
    add_index :carts, :client_id
    add_index :carts, :discount_auth_id
    add_index :carts, :store_order_id
    add_index :carts, :store_id    
  end
end
