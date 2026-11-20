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
end
