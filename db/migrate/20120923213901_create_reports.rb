class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :name
      t.string :csv_file
      t.string :pdf_file

      t.timestamps
    end
  end
end
