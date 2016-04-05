class AddTimestampsToStatements < ActiveRecord::Migration
  def change
    add_column :statements, :created_at, :datetime, null: false
    add_column :statements, :updated_at, :datetime, null: false
    add_column :statements, :locked_at, :datetime
    add_column :statements, :void_at, :datetime
    add_column :statements, :paid_at, :datetime
  end
end
