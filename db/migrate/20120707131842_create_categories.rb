class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.boolean :has_options, :default=>false
      t.boolean :type_unit, :default=>false
      t.boolean :multi, :default=>false
      t.boolean :hidden, :default=>false
      t.integer :base_product
      t.string :flavor_code_src
      t.string :flavor_code_dst
      t.string :size_code_src
      t.string :size_code_dst

      t.timestamps
    end
  end
end
