# Event Audit Log Column Name Fix - Complete ✅

## Issue Fixed
Event creation was failing with error: `ActiveRecord::DangerousAttributeError (changes is defined by Active Record. Check to make sure that you don't have an attribute or method with the same name.)`

---

## Problem

### Original Error:
```
ActiveRecord::DangerousAttributeError (changes is defined by Active Record. Check to make sure that you don't have an attribute or method with the same name.):

app/models/event_audit_log.rb:19:in `log_action'
app/controllers/alumni_events_controller.rb:89:in `log_audit'
app/controllers/alumni_events_controller.rb:30:in `create'
```

**Cause:** The `event_audit_logs` table had a column named `changes`, which conflicts with ActiveRecord's built-in `changes` method that tracks attribute changes on models.

**ActiveRecord Built-in Method:**
```ruby
# Every ActiveRecord model has this method
model.changes  # Returns a hash of changed attributes
```

**Our Column Name:**
```ruby
# We tried to use 'changes' as a column name
t.text :changes  # CONFLICT!
```

---

## Solution

### Step 1: Rename Database Column

**Migration Created:** `20251219065136_rename_changes_in_event_audit_logs.rb`

```ruby
class RenameChangesInEventAuditLogs < ActiveRecord::Migration[5.2]
  def change
    rename_column :event_audit_logs, :changes, :change_data
  end
end
```

**Migration Run:** ✅ Successfully migrated in 0.0522s

### Step 2: Update EventAuditLog Model

**File:** `app/models/event_audit_log.rb`

**Changed:**
```ruby
# OLD (WRONG):
def self.log_action(event_id, user_id, action, auditable = nil, changes = nil, ip = nil)
  create!(
    # ...
    changes: changes.to_json,
    # ...
  )
end

def parsed_changes
  return {} unless changes.present?
  JSON.parse(changes)
end

# NEW (CORRECT):
def self.log_action(event_id, user_id, action, auditable = nil, change_data = nil, ip = nil)
  create!(
    # ...
    change_data: change_data.to_json,
    # ...
  )
end

def parsed_changes
  return {} unless change_data.present?
  JSON.parse(change_data)
end
```

### Step 3: Update Audit Tab View

**File:** `app/views/alumni_events/_audit_tab.html.erb`

**Changed:**
```erb
<!-- OLD: -->
<% if log.changes.present? && log.parsed_changes.any? %>

<!-- NEW: -->
<% if log.change_data.present? && log.parsed_changes.any? %>
```

---

## Database Schema

### Before:
```ruby
create_table "event_audit_logs" do |t|
  t.text :changes          # CONFLICT with ActiveRecord's changes method
end
```

### After:
```ruby
create_table "event_audit_logs" do |t|
  t.text :change_data      # No conflict - safe column name
end
```

---

## Files Updated

1. ✅ **db/migrate/20251219065136_rename_changes_in_event_audit_logs.rb** - Created and run
2. ✅ **app/models/event_audit_log.rb** - Updated to use `change_data`
3. ✅ **app/views/alumni_events/_audit_tab.html.erb** - Updated to use `change_data`

---

## Controllers (No Changes Needed)

The following controllers use `EventAuditLog.log_action()` but don't need updates because they use a local variable named `changes`:

- ✅ `alumni_events_controller.rb` - Local variable, no conflict
- ✅ `event_expenses_controller.rb` - Method signature is backward compatible
- ✅ `event_incomes_controller.rb` - Method signature is backward compatible
- ✅ `expense_payments_controller.rb` - Method signature is backward compatible

**Example (No Change Needed):**
```ruby
def log_audit(action, auditable, old_attrs = nil)
  changes = old_attrs ? auditable.attributes.to_h.diff(old_attrs) : nil  # Local variable is OK
  EventAuditLog.log_action(
    auditable.id,
    current_user.id,
    action,
    auditable,
    changes,  # Passed to method parameter (now called change_data)
    request.remote_ip
  )
end
```

---

## Why This Happened

ActiveRecord reserves certain method names for internal use. The `changes` method is one of them:

### Reserved ActiveRecord Methods:
- `changes` - Returns hash of changed attributes
- `changed?` - Returns true if any attributes changed
- `changed` - Returns array of changed attribute names
- `previous_changes` - Changes from last save
- `saved_changes` - Same as previous_changes

### Safe Column Names:
- `change_data` ✅
- `change_log` ✅
- `modification_data` ✅
- `audit_changes` ✅
- `data_changes` ✅

**Rule:** Never use ActiveRecord reserved method names as column names.

---

## Testing Checklist

- [x] Migration run successfully
- [x] Database column renamed from `changes` to `change_data`
- [x] EventAuditLog model updated
- [x] Audit tab view updated
- [x] Event creation works without error
- [x] Event editing works without error
- [x] Audit logging records changes correctly
- [x] Audit tab displays change history
- [x] No ActiveRecord conflicts

---

## Usage Example

### Creating an Event (Now Works):
```ruby
# In controller:
def create
  @alumni_event = current_user.alumni_events.build(alumni_event_params)
  
  if @alumni_event.save
    log_audit('create', @alumni_event)  # ✅ Works now!
    redirect_to @alumni_event, notice: 'Event was successfully created.'
  else
    render :new
  end
end
```

### Viewing Change History:
```ruby
# In view:
<% @audit_logs.each do |log| %>
  <% if log.change_data.present? && log.parsed_changes.any? %>
    <% log.parsed_changes.each do |field, values| %>
      <strong><%= field.titleize %>:</strong>
      <%= values[0] %> → <%= values[1] %>
    <% end %>
  <% end %>
<% end %>
```

---

## Summary

The `changes` column in `event_audit_logs` table has been successfully renamed to `change_data` to avoid conflicts with ActiveRecord's built-in `changes` method.

✅ **Migration completed**  
✅ **Model updated**  
✅ **View updated**  
✅ **Event creation/editing now works**  
✅ **Audit logging functional**  

Event creation, editing, and audit logging now work correctly without any ActiveRecord conflicts!

---

**Fixed:** December 19, 2025  
**Migration:** 20251219065136  
**Status:** ✅ Complete - All Audit Logging Issues Resolved
