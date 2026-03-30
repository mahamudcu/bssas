class PaymentLog < ApplicationRecord
  belongs_to :payment
  belongs_to :user, optional: true

  ACTIONS = %w[created approved rejected verified failed callback_received].freeze

  validates :action, presence: true, inclusion: { in: ACTIONS }

  scope :recent, -> { order(created_at: :desc) }

  def self.log(payment, action, user = nil, details = nil, ip_address = nil)
    create(
      payment: payment,
      user: user,
      action: action,
      details: details,
      ip_address: ip_address
    )
  end
end
