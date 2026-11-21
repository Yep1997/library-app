module Api
  class BooksController < BaseController
    def index
      render json: { books: Books::App.list.map(&:to_h) }
    end

    def show
      book = Books::App.find(params[:serial_number])

      render json: BookDetailsResource.new(book)
    end
  end
end
