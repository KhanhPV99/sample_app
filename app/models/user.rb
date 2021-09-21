class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  SIGNUP_ATTRS = %i(name email password password_confirmation).freeze
  attr_accessor :remember_token

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
    length: {minimum: Settings.validations.length.digit_6},
    allow_nil: true

  has_secure_password

  class << self
    # Returns the hash digest of the given string.
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    # Returns a random token
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Remembers a user in the database for use in persistent sessions
  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  # Returns true if the given token matches the digest
  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  # Forgets a user
  def forget
    update_column :remember_digest, nil
  end
end
