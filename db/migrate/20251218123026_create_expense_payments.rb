class CreateExpensePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :expense_payments do |t|
      t.integer :event_expense_id, null: false
      t.decimal :amount_paid, precision: 10, scale: 2, null: false
      t.date :payment_date, null: false
      t.string :payment_method
      t.string :payment_reference
      t.text :notes
      t.integer :paid_by

      t.timestamps
    end

    add_index :expense_payments, :event_expense_id
    add_index :expense_payments, :payment_date
    add_index :expense_payments, :paid_by
  end
end
