require "rails_helper"

RSpec.describe "Books", type: :request do
  describe "GET /books" do
    it "shows all books with their availability" do
      create(:book, title: "Refactoring", author: "Martin Fowler")
      create(:loan, book: create(:book, title: "Domain-Driven Design", author: "Eric Evans"))

      get books_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Refactoring", "Martin Fowler", "Available")
      expect(response.body).to include("Domain-Driven Design", "Eric Evans", "Borrowed")
    end

    it "links each book to its details page" do
      create(:book, serial_number: "000001", title: "Refactoring")

      get books_path

      expect(response.body).to include(%(href="#{book_path("000001")}"))
    end

    it "is the home page" do
      get root_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /books/:serial_number" do
    it "shows the book with its full borrowing history" do
      book = create(:book, serial_number: "000001", title: "Refactoring", author: "Martin Fowler")
      reader = create(:reader, card_number: "100001", full_name: "Anna Kowalska", email: "anna@example.com")
      create(:loan, :returned, book:, reader:,
        borrowed_at: Time.zone.parse("2026-01-10 10:00"), due_on: Date.new(2026, 2, 9), returned_at: Time.zone.parse("2026-02-01 12:30"))

      get book_path("000001")

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Refactoring", "Martin Fowler", "000001", "Available")
      expect(response.body).to include("January 10, 2026 10:00", "February 09, 2026", "February 01, 2026 12:30")
      expect(response.body).to include("Anna Kowalska", "100001", "anna@example.com")
    end

    it "marks a loan that has not been returned yet" do
      create(:loan, book: create(:book, serial_number: "000001"))

      get book_path("000001")

      expect(response.body).to include("Borrowed", "Not returned yet")
    end

    it "responds with not found for an unknown serial number" do
      get book_path("999999")

      expect(response).to have_http_status(:not_found)
    end
  end
end
