# Alumni Event Management System

## Overview
A comprehensive Alumni Event Management System with full financial transparency, expense tracking, income management, and audit logging.

## System Status: Phase 1 Complete ✅

### Completed Components:

#### 1. Database Models & Migrations ✅
- **AlumniEvent**: Main event model with budget tracking
- **EventExpense**: Expense items with quantity, unit cost, and category
- **ExpensePayment**: Partial payment tracking for expenses
- **EventIncome**: Income/fund collection with contributor tracking
- **EventAuditLog**: Complete audit trail for all changes

#### 2. Controllers ✅
- **AlumniEventsController**: Full CRUD + financial summary
- **EventExpensesController**: Expense management
- **ExpensePaymentsController**: Payment tracking
- **EventIncomesController**: Income management
- **EventReportsController**: Reports (structure created)

#### 3. Routes Configuration ✅
```ruby
resources :alumni_events do
  member do
    get 'financial_summary'
  end
  resources :event_expenses
  resources :event_incomes
end

resources :event_expenses do
  resources :expense_payments
end
```

## Features Implemented

### 1. Event Management
- Create, Read, Update, Delete events
- Event types: reunion, workshop, seminar, conference, networking, cultural, sports, fundraising, other
- Event statuses: planned, confirmed, ongoing, completed, cancelled
- Budget setup and tracking
- Registration fee management
- Max attendees tracking

### 2. Expense Management
- Item-wise expense tracking
- Quantity × Unit Cost = Total Cost (automatic calculation)
- Categories: venue, catering, decoration, equipment, transportation, accommodation, marketing, staff, entertainment, other
- Vendor tracking
- Multiple payments per expense (partial payments supported)
- Due amount calculation
- Payment status: unpaid, partially_paid, fully_paid, overpaid

### 3. Income/Fund Management
- Income types: registration_fee, donation, sponsorship, contribution, fundraising, grant, other
- Contributor tracking (linked to User model)
- Payment methods: cash, bank_transfer, cheque, online, mobile_payment, other
- Reference number tracking
- Payment date recording

### 4. Financial Calculations
The system automatically calculates:
- **Total Income**: Sum of all event incomes
- **Total Expenses**: Sum of all expense items
- **Total Paid**: Sum of all payments made
- **Total Due**: Total Expenses - Total Paid
- **Balance**: Total Income - Total Expenses
- **Surplus/Deficit**: Indicates if event is profitable or in deficit
- **Budget Utilization**: Percentage of budget used

### 5. Audit Logging System
- Logs all create, update, delete actions
- Tracks payment additions and deletions
- Records income additions and updates
- Stores IP address of user making changes
- Maintains change history (old vs new values)
- Links to specific users and events

### 6. Role-Based Access Control
Built-in permission checks for:
- **admin**: Full access
- **event_manager**: Can manage events, expenses, incomes
- **treasurer**: Can manage financial aspects
- **viewer**: Read-only access (to be implemented in views)

## Database Schema

### alumni_events
```ruby
t.string :title (required)
t.text :description
t.date :event_date
t.string :event_type
t.string :location
t.string :status (default: 'planned')
t.decimal :budget (precision: 12, scale: 2)
t.decimal :registration_fee (precision: 10, scale: 2)
t.integer :max_attendees
t.integer :user_id (creator)
t.timestamps
```

### event_expenses
```ruby
t.integer :alumni_event_id (required)
t.string :item_name (required)
t.text :description
t.decimal :quantity (precision: 10, scale: 2, default: 1.0)
t.decimal :unit_cost (precision: 10, scale: 2)
t.decimal :total_cost (precision: 12, scale: 2)
t.string :category
t.string :vendor
t.timestamps
```

### expense_payments
```ruby
t.integer :event_expense_id (required)
t.decimal :amount_paid (precision: 10, scale: 2, required)
t.date :payment_date (required)
t.string :payment_method
t.string :payment_reference
t.text :notes
t.integer :paid_by (user_id)
t.timestamps
```

### event_incomes
```ruby
t.integer :alumni_event_id (required)
t.integer :contributor_id (user_id, optional)
t.string :income_type (required)
t.decimal :amount (precision: 10, scale: 2, required)
t.string :payment_method
t.date :payment_date (required)
t.string :reference_number
t.text :notes
t.timestamps
```

### event_audit_logs
```ruby
t.integer :alumni_event_id
t.integer :user_id
t.string :action (required)
t.string :auditable_type
t.integer :auditable_id
t.text :changes (JSON)
t.string :ip_address
t.timestamps
```

## Key Model Methods

### AlumniEvent
```ruby
# Financial calculations
.total_income
.total_expenses
.total_paid
.total_due
.balance
.surplus_or_deficit
.budget_utilization_percentage
.financial_summary

# Grouping
.income_by_type
.expenses_by_category

# Scopes
.upcoming
.past
.by_type(type)
.planned / .confirmed / .ongoing / .completed / .cancelled
```

### EventExpense
```ruby
.amount_paid
.amount_due
.payment_percentage
.payment_status
.fully_paid?
.partially_paid?
```

### ExpensePayment
- Validates amount doesn't exceed due amount
- Automatic paid_by tracking

### EventIncome
```ruby
.contributor_name
```

### EventAuditLog
```ruby
.log_action(event_id, user_id, action, auditable, changes, ip)
.parsed_changes
.user_name
.action_description
```

## API Endpoints

### Events
- `GET /alumni_events` - List all events
- `GET /alumni_events/:id` - Show event with expenses, incomes, audit logs
- `GET /alumni_events/new` - New event form
- `POST /alumni_events` - Create event
- `GET /alumni_events/:id/edit` - Edit event form
- `PATCH /alumni_events/:id` - Update event
- `DELETE /alumni_events/:id` - Delete event
- `GET /alumni_events/:id/financial_summary` - Financial summary (HTML/JSON)

### Expenses
- `POST /alumni_events/:alumni_event_id/event_expenses` - Add expense
- `PATCH /alumni_events/:alumni_event_id/event_expenses/:id` - Update expense
- `DELETE /alumni_events/:alumni_event_id/event_expenses/:id` - Delete expense

### Payments
- `POST /event_expenses/:event_expense_id/expense_payments` - Record payment
- `DELETE /event_expenses/:event_expense_id/expense_payments/:id` - Delete payment

### Income
- `POST /alumni_events/:alumni_event_id/event_incomes` - Record income
- `PATCH /alumni_events/:alumni_event_id/event_incomes/:id` - Update income
- `DELETE /alumni_events/:alumni_event_id/event_incomes/:id` - Delete income

### Reports (Structure ready)
- `GET /event_reports` - Reports index
- `GET /event_reports/expenses_report` - Expense reports
- `GET /event_reports/incomes_report` - Income reports
- `GET /event_reports/financial_summary` - Overall financial summary
- `GET /event_reports/export_pdf` - PDF export
- `GET /event_reports/export_excel` - Excel export

## Next Steps (Phase 2)

### 1. Create Views ⏳
- Event index page with filters (status, type)
- Event show page with tabs:
  - Overview
  - Expenses (with add/edit/delete forms)
  - Income (with add/edit/delete forms)
  - Financial Summary
  - Audit Logs
- Event new/edit forms
- Financial dashboard

### 2. Implement Report Views ⏳
- Expense reports (itemized, by category, paid vs due)
- Income reports (by type, by contributor)
- Financial summary reports
- PDF export functionality (using Prawn or Wicked PDF)
- Excel export (using XLSX or CSV)

### 3. Add User Interface Features ⏳
- Charts and graphs for financial data
- Budget progress bars
- Payment status indicators
- Search and filter functionality
- Date range selectors
- Export buttons

### 4. Enhance Security ⏳
- CSRF protection (already in Rails)
- Parameter sanitization (already implemented)
- SQL injection prevention (using ActiveRecord)
- Authorization middleware

### 5. Add Notifications ⏳
- Email notifications for payment due
- Budget threshold alerts
- Event deadline reminders

## Usage Example

### Creating an Event
```ruby
event = current_user.alumni_events.create!(
  title: "Annual Alumni Reunion 2025",
  description: "Our yearly gathering",
  event_date: "2025-06-15",
  event_type: "reunion",
  location: "Grand Hall",
  status: "planned",
  budget: 50000,
  registration_fee: 500,
  max_attendees: 100
)
```

### Adding an Expense
```ruby
expense = event.event_expenses.create!(
  item_name: "Venue Rental",
  description: "Grand Hall for 1 day",
  quantity: 1,
  unit_cost: 15000,
  category: "venue",
  vendor: "Grand Hall Ltd"
)
# total_cost is automatically calculated as 15000
```

### Recording a Payment
```ruby
payment = expense.expense_payments.create!(
  amount_paid: 7500,
  payment_date: Date.today,
  payment_method: "bank_transfer",
  payment_reference: "TXN123456",
  notes: "Advance payment - 50%",
  paid_by: current_user.id
)
# Remaining due: 7500
```

### Recording Income
```ruby
income = event.event_incomes.create!(
  contributor_id: user.id,
  income_type: "registration_fee",
  amount: 500,
  payment_method: "online",
  payment_date: Date.today,
  reference_number: "REG-001"
)
```

### Getting Financial Summary
```ruby
summary = event.financial_summary
# Returns:
# {
#   budget: 50000,
#   total_income: 45000,
#   total_expenses: 38000,
#   total_paid: 30000,
#   total_due: 8000,
#   balance: 7000,
#   surplus_or_deficit: { type: 'surplus', amount: 7000 },
#   budget_utilization: 76.0,
#   payment_status: 'partially_paid'
# }
```

## Security Features

1. **Authentication**: Requires logged-in user
2. **Authorization**: Role-based access control
3. **Audit Logging**: All actions tracked with IP addresses
4. **Validation**: Prevents invalid data entry
5. **Business Logic**: Payment amount cannot exceed due amount

## Performance Optimizations

1. **Database Indexes**: On foreign keys, dates, status fields
2. **Eager Loading**: Using `.includes()` to prevent N+1 queries
3. **Decimal Precision**: Proper precision for financial calculations
4. **Cascading Deletes**: Automatic cleanup of related records

## Dependencies

- Rails 5.2+
- PostgreSQL (recommended) or MySQL
- Future: Prawn (PDF generation)
- Future: Rubyzip/XLSX (Excel export)

## Installation & Setup

1. Run migrations:
```bash
rails db:migrate
```

2. Restart server:
```bash
rails restart
```

3. Access the system:
```
http://localhost:3001/alumni_events
```

## Testing

Models created with test fixtures and test files:
- `test/models/alumni_event_test.rb`
- `test/models/event_expense_test.rb`
- `test/models/expense_payment_test.rb`
- `test/models/event_income_test.rb`
- `test/models/event_audit_log_test.rb`

Controllers have test files ready:
- `test/controllers/alumni_events_controller_test.rb`
- `test/controllers/event_expenses_controller_test.rb`
- `test/controllers/expense_payments_controller_test.rb`
- `test/controllers/event_incomes_controller_test.rb`
- `test/controllers/event_reports_controller_test.rb`

## Architecture Decisions

1. **Separate Payment Model**: Allows multiple partial payments per expense
2. **Audit Log Table**: Dedicated table for change tracking instead of paper_trail
3. **Polymorphic Auditable**: Flexible audit logging for any model type
4. **Automatic Calculations**: total_cost calculated automatically from quantity × unit_cost
5. **Soft Validations**: Some fields allow_blank for flexibility
6. **Indexed Foreign Keys**: For query performance
7. **Precision Decimals**: 12,2 for totals, 10,2 for individual amounts

## Support & Maintenance

- All models have proper associations and validations
- Controllers follow REST conventions
- Audit logs provide complete change history
- Permission checks prevent unauthorized access
- Financial calculations are centralized in models

---

**Generated**: 2025-12-18
**Version**: 1.0 (Phase 1 Complete)
**Status**: Backend Complete, Views Pending
