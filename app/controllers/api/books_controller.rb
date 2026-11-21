module Api
  class BooksController < BaseController
    BOOK_ATTRIBUTES = %i[serial_number title author].freeze

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

    private

    def book_params
      attributes = params.expect(book: BOOK_ATTRIBUTES)
      BOOK_ATTRIBUTES.index_with { |attribute| attributes[attribute] }
    end
  end
end
