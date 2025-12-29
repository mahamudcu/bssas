class EventIncome < ApplicationRecord
  # Associations
  belongs_to :alumni_event
  belongs_to :contributor, class_name: 'User', optional: true

  # Validations
  validates :income_type, presence: true, inclusion: { in: %w[registration_fee donation sponsorship contribution fundraising grant other] }
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :payment_date, presence: true
  validates :payment_method, inclusion: { in: %w[cash bank_transfer cheque online mobile_payment other] }, allow_blank: true

  # Constants
  INCOME_TYPES = %w[registration_fee donation sponsorship contribution fundraising grant other].freeze
  PAYMENT_METHODS = %w[cash bank_transfer cheque online mobile_payment other].freeze

  # Scopes
  scope :by_income_type, ->(type) { where(income_type: type) }
  scope :by_contributor, ->(contributor_id) { where(contributor_id: contributor_id) }
  scope :by_payment_method, ->(method) { where(payment_method: method) }
  scope :recent, -> { order(payment_date: :desc, created_at: :desc) }
  scope :by_date_range, ->(start_date, end_date) { where(payment_date: start_date..end_date) }

  # Helper methods
  def contributor_name
    contributor&.name || 'Anonymous'
  end
end
