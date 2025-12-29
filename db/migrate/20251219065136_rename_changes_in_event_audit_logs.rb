class RenameChangesInEventAuditLogs < ActiveRecord::Migration[5.2]
  def change
    rename_column :event_audit_logs, :changes, :change_data
  end
end
