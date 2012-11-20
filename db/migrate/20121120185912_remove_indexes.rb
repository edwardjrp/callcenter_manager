class RemoveIndexes < ActiveRecord::Migration
  def up
    remove_index "users", :name => "index_users_on_idnumber"
    remove_index "users", :name => "index_users_on_username"
  end

  def down
    add_index "users", ["idnumber"], :name => "index_users_on_idnumber", :unique => true
    add_index "users", ["username"], :name => "index_users_on_username", :unique => true
  end
end
