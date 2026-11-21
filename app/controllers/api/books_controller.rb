module Api
  class BooksController < BaseController
    include BookParams

    def index
      render json: BookSummaryResource.new(Books::App.new.list)
    end

    def show
      book = Books::App.new.find(params[:serial_number])

      render json: BookDetailsResource.new(book)
    end

    def create
      book = Books::App.new.add(**book_params)

      render json: BookSummaryResource.new(book), status: :created, location: api_book_url(book.serial_number)
    end

    def destroy
      Books::App.new.remove(params[:serial_number])

      head :no_content
    end
  end
end
