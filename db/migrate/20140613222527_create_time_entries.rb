class CreateTimeEntries < ActiveRecord::Migration
  def change
    create_table :time_entries do |t|
      t.references :user
      t.references :project
      t.references :task
      t.date :entry_date
      t.float :duration_in_hours
      t.string :comments
      t.timestamps
    end
  end
end
