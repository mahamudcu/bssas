class AlumniEvent < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :event_expenses, dependent: :destroy
  has_many :event_incomes, dependent: :destroy
  has_many :event_audit_logs, dependent: :destroy
  has_many :expense_payments, through: :event_expenses
  has_many :event_registrations, dependent: :destroy
  has_many :registered_users, through: :event_registrations, source: :user
  has_many :event_payments, class_name: 'Payment', dependent: :nullify

  # Validations
  validates :title, presence: true, length: { minimum: 3, maximum: 255 }
  validates :status, presence: true, inclusion: { in: %w[planned confirmed ongoing completed cancelled] }
  validates :event_type, inclusion: { in: %w[reunion workshop seminar conference networking cultural sports fundraising other] }, allow_blank: true
  validates :budget, :registration_fee, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :max_attendees, numericality: { only_integer: true, greater_than: 0 }, allow_blank: true

  # Scopes
  scope :planned, -> { where(status: 'planned') }
  scope :confirmed, -> { where(status: 'confirmed') }
  scope :ongoing, -> { where(status: 'ongoing') }
  scope :completed, -> { where(status: 'completed') }
  scope :cancelled, -> { where(status: 'cancelled') }
  scope :upcoming, -> { where('event_date >= ?', Date.today).order(event_date: :asc) }
  scope :past, -> { where('event_date < ?', Date.today).order(event_date: :desc) }
  scope :by_type, ->(type) { where(event_type: type) }

  # Constants
  STATUSES = %w[planned confirmed ongoing completed cancelled].freeze
  EVENT_TYPES = %w[reunion workshop seminar conference networking cultural sports fundraising other].freeze

  # Financial calculations
  def total_income
    event_incomes.sum(:amount)
  end

  def total_expenses
    event_expenses.sum(:total_cost)
  end

  def total_paid
    expense_payments.sum(:amount_paid)
  end

  def total_due
    total_expenses - total_paid
  end

  def balance
    total_income - total_expenses
  end

  def surplus_or_deficit
    balance >= 0 ? { type: 'surplus', amount: balance } : { type: 'deficit', amount: balance.abs }
  end

  def budget_utilization_percentage
    return 0 if budget.nil? || budget.zero?
    ((total_expenses / budget) * 100).round(2)
  end

  def income_by_type
    event_incomes.group(:income_type).sum(:amount)
  end

  def expenses_by_category
    event_expenses.group(:category).sum(:total_cost)
  end

  def payment_status
    return 'no_expenses' if total_expenses.zero?
    return 'fully_paid' if total_due.zero?
    return 'partially_paid' if total_paid > 0
    'unpaid'
  end

  def financial_summary
    {
      budget: budget || 0,
      total_income: total_income,
      total_expenses: total_expenses,
      total_paid: total_paid,
      total_due: total_due,
      balance: balance,
      surplus_or_deficit: surplus_or_deficit,
      budget_utilization: budget_utilization_percentage,
      payment_status: payment_status
    }
  end
end
