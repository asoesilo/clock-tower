class CreateTableStatementTimeEntries < ActiveRecord::Migration
  def change
    create_table :statement_time_entries do |t|
      t.integer :statement_id, null: false
      t.integer :time_entry_id, null: false
      t.string :state
    end

    remove_column :time_entries, :statement_id, :integer
  end
end
