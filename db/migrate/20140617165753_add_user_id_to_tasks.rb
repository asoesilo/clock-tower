class AddUserIdToTasks < ActiveRecord::Migration
  def up
    add_reference :tasks, :user
  end

  def down
    remove_reference :tasks, :user
  end
end
