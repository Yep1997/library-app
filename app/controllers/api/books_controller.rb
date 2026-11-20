module Api
  class BooksController < BaseController
    def index
      render json: { books: Books::App.list.map(&:to_h) }
    end
  end
end
