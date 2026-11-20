require "rails_helper"

RSpec.describe Books::App do
  describe ".list" do
    it "returns every book with its availability" do
      available_book = create(:book, serial_number: "000001", title: "Refactoring", author: "Martin Fowler")
      borrowed_book = create(:book, serial_number: "000002", title: "Domain-Driven Design", author: "Eric Evans")
      create(:loan, book: borrowed_book)

      expect(described_class.list).to eq([
        Books::BookSummary.new(serial_number: "000001", title: "Refactoring", author: "Martin Fowler", status: :available),
        Books::BookSummary.new(serial_number: "000002", title: "Domain-Driven Design", author: "Eric Evans", status: :borrowed)
      ])
    end

    it "treats a book whose loans were all returned as available" do
      create(:loan, :returned)

      expect(described_class.list.map(&:status)).to eq([ :available ])
    end

    it "orders books by serial number" do
      create(:book, serial_number: "000002")
      create(:book, serial_number: "000001")

      expect(described_class.list.map(&:serial_number)).to eq(%w[000001 000002])
    end
  end
end
