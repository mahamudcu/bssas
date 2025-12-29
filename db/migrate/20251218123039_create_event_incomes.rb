class CreateEventIncomes < ActiveRecord::Migration[5.2]
  def change
    create_table :event_incomes do |t|
      t.integer :alumni_event_id, null: false
      t.integer :contributor_id
      t.string :income_type, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :payment_method
      t.date :payment_date, null: false
      t.string :reference_number
      t.text :notes

      t.timestamps
    end

    add_index :event_incomes, :alumni_event_id
    add_index :event_incomes, :contributor_id
    add_index :event_incomes, :income_type
    add_index :event_incomes, :payment_date
  end
end
