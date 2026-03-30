class CreatePaymentLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_logs do |t|
      t.references :payment, foreign_key: true
      t.references :user, foreign_key: true
      t.string :action, null: false # created, approved, rejected, verified, failed
      t.text :details
      t.string :ip_address

      t.timestamps
    end

    add_index :payment_logs, :action
  end
end
