require "rails_helper"

RSpec.describe Loan, type: :model do
  subject(:loan) { build(:loan) }

  it { is_expected.to belong_to(:book) }
  it { is_expected.to belong_to(:reader) }
  it { is_expected.to validate_presence_of(:borrowed_at) }
  it { is_expected.to validate_presence_of(:due_on) }

  describe "return time" do
    it "cannot be earlier than the borrow time" do
      loan.returned_at = loan.borrowed_at - 1.minute

      expect(loan).to be_invalid
      expect(loan.errors[:returned_at]).to contain_exactly("can't be earlier than the borrow time")
    end
  end

  describe "one active loan per book" do
    let(:book) { create(:book) }

    before { create(:loan, book:) }

    it "rejects a second active loan of the same book" do
      second_loan = build(:loan, book:)

      expect(second_loan).to be_invalid
      expect(second_loan.errors[:book]).to contain_exactly("is already borrowed")
    end

    it "is enforced by the database" do
      second_loan = build(:loan, book:)

      expect { second_loan.save!(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "allows a new loan once the previous one is returned" do
      Loan.update_all(returned_at: Time.current)

      expect(build(:loan, book:)).to be_valid
    end
  end

  describe ".active" do
    it "returns only loans that have not been returned" do
      active_loan = create(:loan)
      create(:loan, :returned)

      expect(described_class.active).to contain_exactly(active_loan)
    end
  end
end
