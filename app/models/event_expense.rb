class EventExpense < ApplicationRecord
  # Associations
  belongs_to :alumni_event
  has_many :expense_payments, dependent: :destroy

  # Validations
  validates :item_name, presence: true, length: { minimum: 2, maximum: 255 }
  validates :quantity, :unit_cost, :total_cost, numericality: { greater_than_or_equal_to: 0 }
  validates :category, inclusion: { in: %w[venue catering decoration equipment transportation accommodation marketing staff entertainment other] }, allow_blank: true

  # Callbacks
  before_validation :calculate_total_cost

  # Constants
  CATEGORIES = %w[venue catering decoration equipment transportation accommodation marketing staff entertainment other].freeze

  # Scopes
  scope :by_category, ->(category) { where(category: category) }
  scope :with_payments, -> { joins(:expense_payments).distinct }
  scope :without_payments, -> { left_joins(:expense_payments).where(expense_payments: { id: nil }) }

  # Calculate amounts
  def amount_paid
    expense_payments.sum(:amount_paid)
  end

  def amount_due
    total_cost - amount_paid
  end

  def payment_percentage
    return 0 if total_cost.zero?
    ((amount_paid / total_cost) * 100).round(2)
  end

  def payment_status
    return 'fully_paid' if amount_due.zero? && total_cost > 0
    return 'partially_paid' if amount_paid > 0 && amount_paid < total_cost
    return 'overpaid' if amount_paid > total_cost
    'unpaid'
  end

  def fully_paid?
    amount_due.zero? && total_cost > 0
  end

  def partially_paid?
    amount_paid > 0 && amount_paid < total_cost
  end

  private

  def calculate_total_cost
    self.total_cost = (quantity || 0) * (unit_cost || 0)
  end
end
