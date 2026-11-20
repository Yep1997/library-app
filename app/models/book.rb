class Book < ApplicationRecord
  validates :serial_number, presence: true, uniqueness: true, six_digit_number: true
  validates :title, presence: true
  validates :author, presence: true
end
