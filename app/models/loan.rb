class Loan < ApplicationRecord
  belongs_to :book
  belongs_to :reader

  scope :active, -> { where(returned_at: nil) }

  validates :borrowed_at, presence: true
  validates :due_on, presence: true
  validates :book, uniqueness: { conditions: -> { active }, message: :already_borrowed }, if: :active?
  validates :returned_at, comparison: { greater_than_or_equal_to: :borrowed_at, message: :earlier_than_borrowed_at },
    if: -> { returned_at && borrowed_at }

  def active? = returned_at.nil?
end
