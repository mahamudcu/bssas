class CreateEventRegistrations < ActiveRecord::Migration[5.2]
  def change
    create_table :event_registrations do |t|
      t.references :user, foreign_key: true, null: false
      t.references :alumni_event, foreign_key: true, null: false
      t.string :status, default: 'pending' # pending, confirmed, cancelled
      t.references :payment, foreign_key: true
      t.text :notes

      t.timestamps
    end

    add_index :event_registrations, [:user_id, :alumni_event_id], unique: true, name: 'idx_event_reg_user_event'
    add_index :event_registrations, :status
  end
end
