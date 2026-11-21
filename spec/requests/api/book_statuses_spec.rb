require "rails_helper"

RSpec.describe "Book status API", type: :request do
  let!(:book) { create(:book, serial_number: "000001", title: "Refactoring", author: "Martin Fowler") }

  before { create(:reader, card_number: "100001") }

  describe "PATCH /api/books/:serial_number/status" do
    it "lends the book to a reader" do
      patch api_book_status_path("000001"), params: { status: "borrowed", card_number: "100001" }, as: :json

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq(
        "book" => { "serial_number" => "000001", "title" => "Refactoring", "author" => "Martin Fowler", "status" => "borrowed" }
      )
    end

    it "marks a borrowed book as returned" do
      create(:loan, book:)

      patch api_book_status_path("000001"), params: { status: "available" }, as: :json

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.dig("book", "status")).to eq("available")
    end

    it "responds with conflict when lending a book that is already borrowed" do
      create(:loan, book:)

      patch api_book_status_path("000001"), params: { status: "borrowed", card_number: "100001" }, as: :json

      expect(response).to have_http_status(:conflict)
      expect(response.parsed_body).to eq("error" => "Book 000001 is already borrowed")
    end

    it "responds with conflict when returning a book that is not borrowed" do
      patch api_book_status_path("000001"), params: { status: "available" }, as: :json

      expect(response).to have_http_status(:conflict)
      expect(response.parsed_body).to eq("error" => "Book 000001 is not borrowed")
    end

    it "responds with unprocessable content for an unknown reader" do
      patch api_book_status_path("000001"), params: { status: "borrowed", card_number: "999999" }, as: :json

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.parsed_body).to eq("error" => "Reader 999999 not found")
    end

    it "responds with unprocessable content for an unknown status" do
      patch api_book_status_path("000001"), params: { status: "lost" }, as: :json

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.parsed_body).to eq("error" => "Status must be one of: borrowed, available")
    end

    it "responds with unprocessable content when lending without a card number" do
      patch api_book_status_path("000001"), params: { status: "borrowed" }, as: :json

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.parsed_body).to eq("error" => "Card number is required to borrow a book")
    end

    it "responds with not found for an unknown serial number" do
      patch api_book_status_path("999999"), params: { status: "available" }, as: :json

      expect(response).to have_http_status(:not_found)
    end
  end
end
