class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.boolean :has_options, :default=>false
      t.boolean :type_unit, :default=>false
      t.boolean :multi, :default=>false
      t.boolean :hidden, :default=>false
      t.integer :base_product

      t.timestamps
    end
  end
end
