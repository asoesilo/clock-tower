class CreateStatementPeroidTable < ActiveRecord::Migration
  def change
    create_table :statement_periods do |t|
      t.string :from
      t.string :to
      t.integer :draft_days
    end
  end
end
