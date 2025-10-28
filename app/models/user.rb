# app/models/user.rb
class User < ApplicationRecord
  has_secure_password
  has_secure_token :api_token

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8 }, on: :create
  validates :name, presence: true

  validate :password_complexity, if: :password_digest_changed?


  def password_complexity
    return if password.blank?

    unless password =~ /[A-Z]/
      errors.add :password, "must contain at least one uppercase letter"
    end

    unless password =~ /[^A-Za-z0-9]/
      errors.add :password, "must contain at least one special character"
    end
  end
end
