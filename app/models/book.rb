class Book < ApplicationRecord
  has_many :loans
  has_one :active_loan, -> { active }, class_name: "Loan"

  validates :serial_number, presence: true, uniqueness: true, six_digit_number: true
  validates :title, presence: true
  validates :author, presence: true
end
