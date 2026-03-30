class EventRegistration < ApplicationRecord
  belongs_to :user
  belongs_to :alumni_event
  belongs_to :payment, optional: true

  STATUSES = %w[pending confirmed cancelled].freeze

  validates :status, inclusion: { in: STATUSES }
  validates :user_id, uniqueness: { scope: :alumni_event_id, message: 'already registered for this event' }

  scope :confirmed, -> { where(status: 'confirmed') }
  scope :pending_registrations, -> { where(status: 'pending') }
  scope :cancelled, -> { where(status: 'cancelled') }

  def confirm!
    update(status: 'confirmed')
  end

  def cancel!
    update(status: 'cancelled')
  end

  def confirmed?
    status == 'confirmed'
  end
end
