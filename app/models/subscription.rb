class Subscription < ApplicationRecord
  belongs_to :user
  has_many :payments, dependent: :nullify

  PLAN_TYPES = %w[monthly yearly].freeze
  STATUSES = %w[active expired cancelled].freeze

  validates :plan_type, presence: true, inclusion: { in: PLAN_TYPES }
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: STATUSES }
  validates :start_date, presence: true
  validates :end_date, presence: true

  scope :active, -> { where(status: 'active') }
  scope :expired, -> { where(status: 'expired') }
  scope :monthly, -> { where(plan_type: 'monthly') }
  scope :yearly, -> { where(plan_type: 'yearly') }
  scope :due, -> { active.where('next_due_date <= ?', Date.today) }

  before_validation :set_dates, on: :create

  def expired?
    end_date < Date.today
  end

  def active?
    status == 'active' && !expired?
  end

  def renew!
    if plan_type == 'monthly'
      update(start_date: Date.today, end_date: 1.month.from_now, next_due_date: 1.month.from_now, status: 'active')
    else
      update(start_date: Date.today, end_date: 1.year.from_now, next_due_date: 1.year.from_now, status: 'active')
    end
  end

  def total_paid
    payments.where(status: 'success').sum(:amount)
  end

  private

  def set_dates
    self.start_date ||= Date.today
    if plan_type == 'monthly'
      self.end_date ||= start_date + 1.month
      self.next_due_date ||= start_date + 1.month
    elsif plan_type == 'yearly'
      self.end_date ||= start_date + 1.year
      self.next_due_date ||= start_date + 1.year
    end
  end
end
