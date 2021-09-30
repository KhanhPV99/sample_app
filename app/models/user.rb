class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

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
end
