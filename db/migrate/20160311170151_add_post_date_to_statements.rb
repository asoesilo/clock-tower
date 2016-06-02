class AddPostDateToStatements < ActiveRecord::Migration
  def change
    add_column :statements, :post_date, :datetime
  end
end
