require "rails_helper"

RSpec.describe SixDigitNumberValidator, type: :model do
  subject(:record) { record_class.new }

  let(:record_class) do
    Class.new do
      include ActiveModel::Validations

      attr_accessor :number

      validates :number, six_digit_number: true

      def self.name = "Record"
    end
  end

  it { is_expected.to allow_values("000000", "000123", "999999").for(:number) }
  it { is_expected.not_to allow_values("12345", "1234567", "12a456", " 123456", "123456\n").for(:number) }

  it "reports an error describing the expected format" do
    record.number = "123"

    record.validate

    expect(record.errors[:number]).to contain_exactly("must be a six-digit number")
  end
end
