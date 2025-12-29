class CreateEventAuditLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :event_audit_logs do |t|
      t.integer :alumni_event_id
      t.integer :user_id
      t.string :action, null: false
      t.string :auditable_type
      t.integer :auditable_id
      t.text :changes
      t.string :ip_address

      t.timestamps
    end

    add_index :event_audit_logs, :alumni_event_id
    add_index :event_audit_logs, :user_id
    add_index :event_audit_logs, [:auditable_type, :auditable_id]
    add_index :event_audit_logs, :created_at
  end
end
