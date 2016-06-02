class AddHasTaxToUsersTaxInfoToTe < ActiveRecord::Migration
  def change
    add_column :users, :has_tax, :boolean
    add_column :time_entries, :has_tax, :boolean
    add_column :time_entries, :tax_desc, :string
    add_column :time_entries, :tax_percent, :integer
  end
end
