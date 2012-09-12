class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :code
      t.text :description
      t.text :custom_description
      t.text :generated_description
      t.string :minimum_price
      t.boolean :hidden
      t.boolean :secure
      t.string :effective_days
      t.string :order_sources
      t.string :service_methods
      t.date :expiration_date
      t.date :effective_date
      t.boolean :enable,  default: true
      t.boolean :discontinued ,  default: false
      t.timestamps
    end

    add_index :coupons, :code, unique: true
  end
end
