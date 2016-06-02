class RemoveStateFromStatement < ActiveRecord::Migration
  def change
    remove_column :statements, :state, :string
  end
end
