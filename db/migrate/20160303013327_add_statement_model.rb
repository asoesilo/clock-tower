class AddStatementModel < ActiveRecord::Migration
  def change
    create_table :statements do |t|
      t.string :state
      t.integer :user_id
      t.datetime :from
      t.datetime :to
      t.decimal :subtotal
      t.decimal :tax_amount
    end

    add_column :time_entries, :statement_id, :integer
  end
end
