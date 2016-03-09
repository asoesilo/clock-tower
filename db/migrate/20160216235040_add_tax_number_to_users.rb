class AddTaxNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tax_number, :string
  end
end
