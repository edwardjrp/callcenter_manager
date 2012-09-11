class CreateImportLogs < ActiveRecord::Migration
  def change
    create_table :import_logs do |t|
      t.string :log_type
      t.string :state

      t.timestamps
    end
  end
end
