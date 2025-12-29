class CreateEventExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :event_expenses do |t|
      t.integer :alumni_event_id, null: false
      t.string :item_name, null: false
      t.text :description
      t.decimal :quantity, precision: 10, scale: 2, default: 1.0
      t.decimal :unit_cost, precision: 10, scale: 2, default: 0.0
      t.decimal :total_cost, precision: 12, scale: 2, default: 0.0
      t.string :category
      t.string :vendor

      t.timestamps
    end

    add_index :event_expenses, :alumni_event_id
    add_index :event_expenses, :category
  end
end
