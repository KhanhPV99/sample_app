class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  SIGNUP_ATTRS = %i(name email password password_confirmation).freeze

  validates :name, presence: true,
    length: {
      minimum: Settings.validations.length.digit_5,
      maximum: Settings.validations.length.digit_50
    }
  validates :email, presence: true,
    length: {maximum: Settings.validations.length.digit_255},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.validations.length.digit_6}

  has_secure_password

  # Returns the hash digest of the given string.
  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost: cost
  end
end
