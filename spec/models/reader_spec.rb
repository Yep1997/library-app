require "rails_helper"

RSpec.describe Reader, type: :model do
  subject(:reader) { build(:reader) }

  describe "card number" do
    it { is_expected.to validate_presence_of(:card_number) }
    it { is_expected.to validate_uniqueness_of(:card_number).ignoring_case_sensitivity }
    it { is_expected.to have_db_index(:card_number).unique }
    it { is_expected.to allow_value("000123").for(:card_number) }
    it { is_expected.not_to allow_values("12345", "1234567", "12a456").for(:card_number) }
  end

  describe "full name" do
    it { is_expected.to validate_presence_of(:full_name) }
  end

  describe "email" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to have_db_index(:email).unique }
    it { is_expected.not_to allow_value("not-an-email").for(:email) }

    it "is normalized to a stripped, lowercase address" do
      reader = build(:reader, email: "  Jane.Doe@Example.COM ")

      expect(reader.email).to eq("jane.doe@example.com")
    end
  end
end
