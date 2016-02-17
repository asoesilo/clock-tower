class CreateLocationModel < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :vacation_name
      t.string :tax_percent
      t.string :tax_name
    end
  end
end
