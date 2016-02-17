class CreateLocationModel < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :province
      t.string :holiday_code
      t.integer :tax_percent
      t.string :tax_name
      t.string :user_id
    end
  end
end
