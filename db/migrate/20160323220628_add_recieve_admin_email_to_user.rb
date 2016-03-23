class AddRecieveAdminEmailToUser < ActiveRecord::Migration
  def change
    add_column :users, :receive_admin_email, :boolean, null: false, default: false
  end
end
