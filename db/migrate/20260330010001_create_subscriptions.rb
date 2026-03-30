class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.references :user, foreign_key: true, null: false
      t.string :plan_type, null: false # monthly, yearly
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :status, default: 'active' # active, expired, cancelled
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.date :next_due_date
      t.boolean :auto_renew, default: false
      t.text :notes

      t.timestamps
    end

    add_index :subscriptions, :plan_type
    add_index :subscriptions, :status
    add_index :subscriptions, :next_due_date
  end
end
