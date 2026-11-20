class Reader < ApplicationRecord
  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :card_number, presence: true, uniqueness: true, six_digit_number: true
  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
