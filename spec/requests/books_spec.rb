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

    it "is the home page" do
      get root_path

      expect(response).to have_http_status(:ok)
    end
  end
end
