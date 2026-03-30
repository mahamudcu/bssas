class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :subscription, optional: true
  belongs_to :alumni_event, optional: true
  belongs_to :approved_by, class_name: 'User', foreign_key: 'approved_by_id', optional: true
  has_many :payment_logs, dependent: :destroy
  has_one :event_registration, dependent: :nullify

  PAYMENT_TYPES = %w[membership_monthly membership_yearly event_fee].freeze
  PAYMENT_METHODS = %w[sslcommerz cash bank_transfer cheque mobile_payment].freeze
  STATUSES = %w[pending success failed cancelled].freeze

  validates :payment_type, presence: true, inclusion: { in: PAYMENT_TYPES }
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :payment_method, presence: true, inclusion: { in: PAYMENT_METHODS }
  validates :status, inclusion: { in: STATUSES }
  validates :transaction_id, uniqueness: true, allow_nil: true

  before_create :generate_transaction_id

  scope :successful, -> { where(status: 'success') }
  scope :pending_payments, -> { where(status: 'pending') }
  scope :failed, -> { where(status: 'failed') }
  scope :membership, -> { where(payment_type: ['membership_monthly', 'membership_yearly']) }
  scope :event_fees, -> { where(payment_type: 'event_fee') }
  scope :online, -> { where(payment_method: 'sslcommerz') }
  scope :manual, -> { where(payment_method: ['cash', 'bank_transfer', 'cheque', 'mobile_payment']) }
  scope :by_month, ->(date) { where('payments.created_at >= ? AND payments.created_at <= ?', date.beginning_of_month, date.end_of_month) }
  scope :by_year, ->(year) { where('YEAR(payments.created_at) = ?', year) }
  scope :recent, -> { order(created_at: :desc) }

  def self.page_results(page, per_page = 25)
    page = (page || 1).to_i
    offset = (page - 1) * per_page
    limit(per_page).offset(offset)
  end

  def successful?
    status == 'success'
  end

  def pending?
    status == 'pending'
  end

  def manual_payment?
    payment_method != 'sslcommerz'
  end

  def approve!(admin)
    return false unless pending? && manual_payment?
    update(status: 'success', approved_by: admin, approved_at: Time.current)
  end

  def reject!(admin)
    return false unless pending?
    update(status: 'failed', approved_by: admin, approved_at: Time.current)
  end

  def payment_type_label
    case payment_type
    when 'membership_monthly' then 'Monthly Membership'
    when 'membership_yearly' then 'Yearly Membership'
    when 'event_fee' then 'Event Fee'
    else payment_type.titleize
    end
  end

  def status_badge_class
    case status
    when 'success' then 'badge-success'
    when 'pending' then 'badge-warning'
    when 'failed' then 'badge-danger'
    when 'cancelled' then 'badge-secondary'
    else 'badge-info'
    end
  end

  private

  def generate_transaction_id
    self.transaction_id ||= "TXN-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(6).upcase}"
  end
end
