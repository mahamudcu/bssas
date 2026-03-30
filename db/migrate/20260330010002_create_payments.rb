class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.references :user, foreign_key: true, null: false
      t.string :payment_type, null: false # membership_monthly, membership_yearly, event_fee
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :payment_method, null: false # sslcommerz, cash, bank_transfer
      t.string :status, default: 'pending' # pending, success, failed, cancelled
      t.string :transaction_id
      t.string :sslcommerz_tran_id
      t.string :sslcommerz_val_id
      t.text :gateway_response
      t.references :subscription, foreign_key: true
      t.references :alumni_event, foreign_key: true
      t.integer :approved_by_id
      t.datetime :approved_at
      t.string :reference_number
      t.text :notes
      t.date :payment_for_month # for monthly payments
      t.integer :payment_for_year # for yearly payments

      t.timestamps
    end

    add_index :payments, :payment_type
    add_index :payments, :status
    add_index :payments, :transaction_id, unique: true
    add_index :payments, :sslcommerz_tran_id
    add_index :payments, :payment_for_month
    add_index :payments, :approved_by_id
  end
end
