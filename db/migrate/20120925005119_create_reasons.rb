class CreateReasons < ActiveRecord::Migration
  def change
    create_table :reasons do |t|
      t.text :content

      t.timestamps
    end

    add_column :carts, :reason_id, :integer
  end
end
