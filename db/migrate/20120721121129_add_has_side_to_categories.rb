class AddHasSideToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :has_sides, :boolean, default: false
  end
end
