require "rails_helper"

RSpec.describe "Books API", type: :request do
  describe "GET /api/books" do
    it "lists all books with their availability" do
      create(:book, serial_number: "000001", title: "Refactoring", author: "Martin Fowler")
      create(:loan, book: create(:book, serial_number: "000002", title: "Domain-Driven Design", author: "Eric Evans"))

      get api_books_path

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq(
        "books" => [
          { "serial_number" => "000001", "title" => "Refactoring", "author" => "Martin Fowler", "status" => "available" },
          { "serial_number" => "000002", "title" => "Domain-Driven Design", "author" => "Eric Evans", "status" => "borrowed" }
        ]
      )
    end

    it "returns an empty list when the library has no books" do
      get api_books_path

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq("books" => [])
    end
  end

  describe "GET /api/books/:serial_number" do
    it "returns the book with its full borrowing history" do
      book = create(:book, serial_number: "000001", title: "Refactoring", author: "Martin Fowler")
      reader = create(:reader, card_number: "100001", full_name: "Anna Kowalska", email: "anna@example.com")
      create(:loan, :returned, book:, reader:,
        borrowed_at: Time.zone.parse("2026-01-10 10:00"), due_on: Date.new(2026, 2, 9), returned_at: Time.zone.parse("2026-02-01 12:30"))

      get api_book_path("000001")

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq(
        "book" => {
          "serial_number" => "000001",
          "title" => "Refactoring",
          "author" => "Martin Fowler",
          "status" => "available",
          "loans" => [
            {
              "borrowed_at" => "2026-01-10T10:00:00.000Z",
              "due_on" => "2026-02-09",
              "returned_at" => "2026-02-01T12:30:00.000Z",
              "reader" => { "card_number" => "100001", "full_name" => "Anna Kowalska", "email" => "anna@example.com" }
            }
          ]
        }
      )
    end

    it "responds with not found for an unknown serial number" do
      get api_book_path("999999")

      expect(response).to have_http_status(:not_found)
      expect(response.parsed_body).to eq("error" => "Book 999999 not found")
    end
  end

  describe "POST /api/books" do
    it "adds the book and returns it" do
      post api_books_path, params: { book: { serial_number: "000001", title: "Refactoring", author: "Martin Fowler" } }, as: :json

      expect(response).to have_http_status(:created)
      expect(response.location).to end_with(api_book_path("000001"))
      expect(response.parsed_body).to eq(
        "book" => { "serial_number" => "000001", "title" => "Refactoring", "author" => "Martin Fowler", "status" => "available" }
      )
    end

    it "responds with validation errors when the data is invalid" do
      post api_books_path, params: { book: { serial_number: "123", title: "", author: "Martin Fowler" } }, as: :json

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.parsed_body).to eq(
        "errors" => { "serial_number" => [ "must be a six-digit number" ], "title" => [ "can't be blank" ] }
      )
    end

    it "responds with validation errors when fields are missing" do
      post api_books_path, params: { book: { title: "Refactoring" } }, as: :json

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.parsed_body["errors"].keys).to contain_exactly("serial_number", "author")
    end

    it "responds with bad request when the payload is empty" do
      post api_books_path, params: {}, as: :json

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "DELETE /api/books/:serial_number" do
    it "removes the book" do
      create(:book, serial_number: "000001")

      delete api_book_path("000001")

      expect(response).to have_http_status(:no_content)
      expect(Book.exists?(serial_number: "000001")).to be(false)
    end

    it "responds with not found for an unknown serial number" do
      delete api_book_path("999999")

      expect(response).to have_http_status(:not_found)
      expect(response.parsed_body).to eq("error" => "Book 999999 not found")
    end
  end
end
