class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  attr_accessor  :login
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,:authentication_keys => [:login]

  mount_uploader :image, AvatarUploader


  ROLE = {
    admin: 'admin',
    super_admin: 'super_admin',
    student: 'student',
    x_student: 'x_student',
    alumni: 'alumni',
    teacher: 'teacher',
  }

  scope :admins, ->{ where(role: ROLE[:admin]) }
  scope :students, ->{ where(role: ROLE[:students]) }
  scope :alumnies, ->{ where(role: ROLE[:alumni]) }
  scope :ex_students, ->{ where(role: ROLE[:x_student]) }
  scope :request_students, -> { where("role IS NULL OR role = ?", ROLE[:student]) }
  scope :teachers, ->{ where(role: ROLE[:teacher]) }

  def is_admin?
    self.role == ROLE[:admin] || self.role == ROLE[:super_admin]
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
end
