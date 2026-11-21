require "rails_helper"

RSpec.describe Readers::App do
  subject(:app) { described_class.new }

  describe "#list" do
    it "returns every reader ordered by full name" do
      create(:reader, card_number: "100002", full_name: "Jan Nowak")
      create(:reader, card_number: "100001", full_name: "Anna Kowalska")

      expect(app.list).to eq([
        Readers::ReaderSummary.new(card_number: "100001", full_name: "Anna Kowalska"),
        Readers::ReaderSummary.new(card_number: "100002", full_name: "Jan Nowak")
      ])
    end
  end
end
