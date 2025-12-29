class EventAuditLog < ApplicationRecord
  # Associations
  belongs_to :alumni_event, optional: true
  belongs_to :user, optional: true
  belongs_to :auditable, polymorphic: true, optional: true

  # Validations
  validates :action, presence: true

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :by_event, ->(event_id) { where(alumni_event_id: event_id) }
  scope :by_action, ->(action) { where(action: action) }
  scope :by_auditable_type, ->(type) { where(auditable_type: type) }

  # Class method to log an action
  def self.log_action(event_id, user_id, action, auditable = nil, change_data = nil, ip = nil)
    create!(
      alumni_event_id: event_id,
      user_id: user_id,
      action: action,
      auditable_type: auditable&.class&.name,
      auditable_id: auditable&.id,
      change_data: change_data.to_json,
      ip_address: ip
    )
  end

  # Get parsed changes
  def parsed_changes
    return {} unless change_data.present?
    JSON.parse(change_data)
  rescue JSON::ParserError
    {}
  end

  # User name
  def user_name
    user&.name || 'System'
  end

  # Action description
  def action_description
    case action
    when 'create' then 'Created'
    when 'update' then 'Updated'
    when 'destroy' then 'Deleted'
    when 'payment_added' then 'Added Payment'
    when 'income_added' then 'Added Income'
    else action.titleize
    end
  end
end
