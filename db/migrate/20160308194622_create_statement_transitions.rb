class CreateStatementTransitions < ActiveRecord::Migration
  def change
    create_table :statement_transitions do |t|
      t.string :to_state, null: false
      t.text :metadata, default: "{}"
      t.integer :sort_key, null: false
      t.integer :statement_id, null: false
      t.boolean :most_recent, null: false
      t.timestamps null: false
    end

    add_index(:statement_transitions,
              [:statement_id, :sort_key],
              unique: true,
              name: "index_statement_transitions_parent_sort")
    add_index(:statement_transitions,
              [:statement_id, :most_recent],
              unique: true,
              where: 'most_recent',
              name: "index_statement_transitions_parent_most_recent")
  end
end
