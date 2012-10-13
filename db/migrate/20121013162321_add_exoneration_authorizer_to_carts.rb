class AddExonerationAuthorizerToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :exoneration_authorizer, :integer
  end
end
