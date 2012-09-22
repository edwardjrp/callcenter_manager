class ChangeRolesMaskForOperator < ActiveRecord::Migration
  def up
    User.update_all({role_mask: 2}, {role_mask: 4})
  end

  def down
    User.update_all({role_mask: 4}, {role_mask: 2})
  end
end
