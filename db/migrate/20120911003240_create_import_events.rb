class CreateImportEvents < ActiveRecord::Migration
  def change
    create_table :import_events do |t|
      t.integer :import_log_id
      t.string :name
      t.string :subject
      t.text :message

      t.timestamps
    end
  end
end
