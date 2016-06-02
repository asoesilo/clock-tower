class TaxPercentTypeToDecimal < ActiveRecord::Migration
  def change
    change_column :time_entries, :tax_percent, :decimal, precision: 5, scale: 3
    change_column :locations, :tax_percent, :decimal, precision: 5, scale: 3
  end
end
