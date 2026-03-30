class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  attr_accessor  :login
  attr_accessor  :user_type
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,:authentication_keys => [:login]

  mount_uploader :image, AvatarUploader

  # Associations
  has_many :alumni_events, dependent: :destroy
  has_many :event_incomes, foreign_key: 'contributor_id', dependent: :nullify
  has_many :event_audit_logs, dependent: :nullify
  has_many :subscriptions, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :event_registrations, dependent: :destroy
  has_many :registered_events, through: :event_registrations, source: :alumni_event

  ROLE = {
    admin: 'admin',
    # super_admin: 'super_admin',
    student: 'student',
    x_student: 'x_student',
    alumni: 'alumni',
    member: 'member',
    teacher: 'teacher',
  }

  scope :admins, ->{ where(role: ROLE[:admin]) }
  scope :students, ->{ where(role: ROLE[:students]) }
  scope :alumnies, ->{ where(role: ROLE[:alumni]) }
  scope :ex_students, ->{ where(role: ROLE[:x_student]) }
  scope :members, ->{ where(role: ROLE[:member]) }
  scope :request_students, -> { where("role = ?", ROLE[:student]) }
  # scope :request_students, -> { where("role IS NULL OR role = ?", ROLE[:student]) }
  scope :teachers, ->{ where(role: ROLE[:teacher]) }

  before_save :set_role

  def is_admin?
    self.role == ROLE[:admin] || self.role == ROLE[:super_admin]
  end

  def is_full_access?
    self.role == ROLE[:admin] || self.role == ROLE[:super_admin]
  end

  def is_edit_access?
    self.role == ROLE[:member] || is_full_access?
  end

  def is_show_access?
    self.role == ROLE[:alumni] || is_edit_access?
  end

  def set_role
    if user_type.present?
      case user_type
      when 'Member'
        self.role = ROLE[:member]
      when 'Alumni'
        self.role = ROLE[:alumni]
      when 'Student'
        self.role = ROLE[:student]
      else
        self.role = ROLE[:student]
        # self.role = ROLE[:admin]
      end
    end
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(phone) = :value OR lower(email) = :value", {value: login.strip.downcase}]).first
  end

  def self.find_recoverable_or_initialize_with_errors required_attributes, attributes, error = :invalid
    (case_insensitive_keys || []).each {|k| attributes[k].try(:downcase!)}

    attributes = attributes.slice(*required_attributes)
    attributes.delete_if {|_key, value| value.blank?}

    if attributes.keys.size == required_attributes.size
      if attributes.key?(:login)
        login = attributes.delete(:login)
        record = find_record(login)
      else
        record = where(attributes).first
      end
    end

    unless record
      record = new({login: login})
      record.errors.add(:forgot_password, 'no user found')
    end
    record
  end

  def self.find_record login
    where(["phone = :value OR email = :value", {value: login}]).first
  end

  def active_subscription
    subscriptions.active.order(created_at: :desc).first
  end

  def has_active_subscription?
    active_subscription.present?
  end

  def total_paid
    payments.successful.sum(:amount)
  end

  def pending_dues
    payments.pending_payments.sum(:amount)
  end

  def registered_for_event?(event)
    event_registrations.where(alumni_event: event).exists?
  end

  def send_mail
    UserMailer.welcome_email(self).deliver_now
    # UserMailer.welcome_email(@user).deliver_later
  end

end
