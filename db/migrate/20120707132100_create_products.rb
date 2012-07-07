class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer  "category_id"
      t.string   "productcode"
      t.string   "productname"
      t.string   "options"
      t.string   "sizecode"
      t.string   "flavorcode"
      t.string   "optionselectiongrouptype"
      t.string   "productoptionselectiongroup"
      t.timestamps
    end
    
    add_index :products, :productcode
    add_index :products, :options
  end
end
