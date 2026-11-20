require "rails_helper"

RSpec.describe Book, type: :model do
  subject(:book) { build(:book) }

  describe "serial number" do
    it { is_expected.to validate_presence_of(:serial_number) }
    it { is_expected.to validate_uniqueness_of(:serial_number).ignoring_case_sensitivity }
    it { is_expected.to have_db_index(:serial_number).unique }
    it { is_expected.to allow_value("000123").for(:serial_number) }
    it { is_expected.not_to allow_values("12345", "1234567", "12a456").for(:serial_number) }
  end

  describe "title" do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe "author" do
    it { is_expected.to validate_presence_of(:author) }
  end
end
