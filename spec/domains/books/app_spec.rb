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

  describe ".find" do
    let(:book) { create(:book, serial_number: "000001", title: "Refactoring", author: "Martin Fowler") }
    let(:reader) { create(:reader, card_number: "100001", full_name: "Anna Kowalska", email: "anna@example.com") }

    it "returns the book with its borrowing history, newest first" do
      older_loan = create(:loan, :returned, book:, reader:, borrowed_at: 2.months.ago).reload
      newer_loan = create(:loan, book:, reader:, borrowed_at: 1.day.ago).reload
      borrower = Books::Borrower.new(card_number: "100001", full_name: "Anna Kowalska", email: "anna@example.com")

      expect(described_class.find("000001")).to eq(
        Books::BookDetails.new(
          serial_number: "000001",
          title: "Refactoring",
          author: "Martin Fowler",
          status: :borrowed,
          loans: [
            Books::LoanEntry.new(borrowed_at: newer_loan.borrowed_at, due_on: newer_loan.due_on, returned_at: nil, borrower:),
            Books::LoanEntry.new(borrowed_at: older_loan.borrowed_at, due_on: older_loan.due_on, returned_at: older_loan.returned_at, borrower:)
          ]
        )
      )
    end

    it "returns an available book with an empty history when it was never borrowed" do
      book

      details = described_class.find("000001")

      expect(details).to have_attributes(status: :available, loans: [])
    end

    it "raises BookNotFound for an unknown serial number" do
      expect { described_class.find("999999") }.to raise_error(Books::BookNotFound, "Book 999999 not found")
    end
  end

  describe ".add" do
    it "adds an available book to the library" do
      summary = described_class.add(serial_number: "000001", title: "Refactoring", author: "Martin Fowler")

      expect(summary).to eq(
        Books::BookSummary.new(serial_number: "000001", title: "Refactoring", author: "Martin Fowler", status: :available)
      )
      expect(Book.find_by(serial_number: "000001")).to have_attributes(title: "Refactoring", author: "Martin Fowler")
    end

    it "raises InvalidBook with validation errors when the data is invalid" do
      create(:book, serial_number: "000001")

      expect { described_class.add(serial_number: "000001", title: "", author: "Martin Fowler") }
        .to raise_error(Books::InvalidBook) { |error|
          expect(error.errors).to eq(serial_number: [ "has already been taken" ], title: [ "can't be blank" ])
        }
    end

    it "does not add a book when the data is invalid" do
      expect { described_class.add(serial_number: "123", title: "Refactoring", author: "Martin Fowler") }
        .to raise_error(Books::InvalidBook)
      expect(Book.count).to eq(0)
    end
  end

  describe ".remove" do
    it "removes the book together with its borrowing history, keeping the readers" do
      book = create(:book, serial_number: "000001")
      reader = create(:reader)
      create(:loan, :returned, book:, reader:)
      create(:loan, book:, reader:)

      described_class.remove("000001")

      expect(Book.exists?(book.id)).to be(false)
      expect(Loan.where(book_id: book.id)).to be_empty
      expect(Reader.exists?(reader.id)).to be(true)
    end

    it "leaves other books untouched" do
      create(:book, serial_number: "000001")
      other_book = create(:book, serial_number: "000002")

      described_class.remove("000001")

      expect(Book.all).to contain_exactly(other_book)
    end

    it "raises BookNotFound for an unknown serial number" do
      expect { described_class.remove("999999") }.to raise_error(Books::BookNotFound, "Book 999999 not found")
    end
  end
end
