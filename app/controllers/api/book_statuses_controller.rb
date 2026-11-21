module Api
  class BookStatusesController < BaseController
    def update
      book = Books::App.new.change_status(
        params[:book_serial_number], status: params[:status], card_number: params[:card_number]
      )

      render json: BookSummaryResource.new(book)
    end
  end
end
