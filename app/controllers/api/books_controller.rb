module Api
  class BooksController < BaseController
    def index
      render json: BookSummaryResource.new(Books::App.list)
    end

    def show
      book = Books::App.find(params[:serial_number])

      render json: BookDetailsResource.new(book)
    end
  end
end
