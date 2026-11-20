class Book < ApplicationRecord
  SERIAL_NUMBER_FORMAT = /\A\d{6}\z/

  validates :serial_number, presence: true, uniqueness: true, format: { with: SERIAL_NUMBER_FORMAT }
  validates :title, presence: true
  validates :author, presence: true
end
