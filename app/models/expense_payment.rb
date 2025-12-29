class ExpensePayment < ApplicationRecord
  # Associations
  belongs_to :event_expense
  belongs_to :paid_by_user, class_name: 'User', foreign_key: 'paid_by', optional: true

  # Validations
  validates :amount_paid, presence: true, numericality: { greater_than: 0 }
  validates :payment_date, presence: true
  validates :payment_method, inclusion: { in: %w[cash bank_transfer cheque online mobile_payment other] }, allow_blank: true
  validate :amount_not_exceeding_due

  # Constants
  PAYMENT_METHODS = %w[cash bank_transfer cheque online mobile_payment other].freeze

  # Scopes
  scope :by_payment_method, ->(method) { where(payment_method: method) }
  scope :recent, -> { order(payment_date: :desc, created_at: :desc) }
  scope :by_date_range, ->(start_date, end_date) { where(payment_date: start_date..end_date) }

  private

  def amount_not_exceeding_due
    return unless event_expense && amount_paid

    current_due = event_expense.amount_due
    current_due += amount_paid if persisted?

    if amount_paid > current_due
      errors.add(:amount_paid, "cannot exceed the due amount of #{current_due}")
    end
  end
end
