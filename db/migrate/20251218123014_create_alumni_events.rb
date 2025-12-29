class CreateAlumniEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :alumni_events do |t|
      t.string :title, null: false
      t.text :description
      t.date :event_date
      t.string :event_type
      t.string :location
      t.string :status, default: 'planned'
      t.decimal :budget, precision: 12, scale: 2, default: 0.0
      t.decimal :registration_fee, precision: 10, scale: 2, default: 0.0
      t.integer :max_attendees
      t.integer :user_id

      t.timestamps
    end

    add_index :alumni_events, :user_id
    add_index :alumni_events, :status
    add_index :alumni_events, :event_date
  end
end
