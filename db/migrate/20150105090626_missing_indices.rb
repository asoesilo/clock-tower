class MissingIndices < ActiveRecord::Migration
  def change
    add_index :time_entries, :user_id
    add_index :time_entries, :project_id
    add_index :time_entries, :task_id
    add_index :time_entries, :entry_date

    add_index :users, :email, unique: true

    add_index :projects, :user_id
    add_index :tasks, :user_id
  end
end
