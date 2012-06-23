class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :auth_token
      t.string :password_digest
      t.integer :role_mask
      t.datetime :last_action_at
      t.integer :login_count, :default=>0
      t.integer :carts_count, :default=>0
      t.string :idnumber
      t.boolean :active, :default=>true

      t.timestamps
    end
    
    add_index :users, :username, :unique=>true
    add_index :users, :idnumber, :unique=>true
    add_index :users, :auth_token
  end
end
