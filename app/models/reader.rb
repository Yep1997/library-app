class Reader < ApplicationRecord
  CARD_NUMBER_FORMAT = /\A\d{6}\z/

  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :card_number, presence: true, uniqueness: true, format: { with: CARD_NUMBER_FORMAT }
  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
