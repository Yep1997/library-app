module Api
  class BooksController < BaseController
    include BookParams

    def index
      render json: BookSummaryResource.new(Books::App.list)
    end

    def show
      book = Books::App.find(params[:serial_number])

      render json: BookDetailsResource.new(book)
    end

    def create
      book = Books::App.add(**book_params)

      render json: BookSummaryResource.new(book), status: :created, location: api_book_url(book.serial_number)
    end

    def destroy
      Books::App.remove(params[:serial_number])

      head :no_content
    end
  end
end
