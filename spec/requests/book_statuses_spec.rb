require "rails_helper"

RSpec.describe "Book status", type: :request do
  let!(:book) { create(:book, serial_number: "000001", title: "Refactoring") }

  before { create(:reader, card_number: "100001", full_name: "Anna Kowalska") }

  describe "book page" do
    it "offers lending an available book to one of the readers" do
      get book_path("000001")

      expect(response.body).to include(%(action="#{book_status_path("000001")}"), "Lend book")
      expect(response.body).to include(%(<option value="100001">Anna Kowalska (100001)</option>))
    end

    it "offers marking a borrowed book as returned" do
      create(:loan, book:)

      get book_path("000001")

      expect(response.body).to include("Mark as returned")
      expect(response.body).not_to include("Lend book")
    end
  end

  describe "PATCH /books/:serial_number/status" do
    it "lends the book and shows its page" do
      patch book_status_path("000001"), params: { status: "borrowed", card_number: "100001" }

      expect(response).to redirect_to(book_path("000001"))
      follow_redirect!
      expect(response.body).to include("Book was lent.", "Borrowed", "Anna Kowalska")
    end

    it "marks the book as returned and shows its page" do
      create(:loan, book:)

      patch book_status_path("000001"), params: { status: "available" }

      expect(response).to redirect_to(book_path("000001"))
      follow_redirect!
      expect(response.body).to include("Book was returned.", "Available")
    end

    it "shows the reason when the status cannot be changed" do
      patch book_status_path("000001"), params: { status: "available" }

      expect(response).to redirect_to(book_path("000001"))
      follow_redirect!
      expect(response.body).to include("Book 000001 is not borrowed")
    end

    it "responds with not found for an unknown serial number" do
      patch book_status_path("999999"), params: { status: "available" }

      expect(response).to have_http_status(:not_found)
    end
  end
end
