class AddPasswordResetRequiredToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_reset_required, :boolean
  end
end
