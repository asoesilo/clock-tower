class CreateLocationModel < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :holiday_code
      t.integer :tax_percent
      t.string :tax_name
    end
  end
end
