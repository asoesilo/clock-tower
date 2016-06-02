class RemoveTotalsFromStatementModel < ActiveRecord::Migration
  def change
    remove_column :statements, :subtotal, :decimal
    remove_column :statements, :tax_amount, :decimal
    remove_column :statements, :total, :decimal
    remove_column :statements, :hours, :decimal
  end
end
