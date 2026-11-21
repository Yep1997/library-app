class BookStatusesController < ApplicationController
  rescue_from Books::BookAlreadyBorrowed, Books::BookNotBorrowed, Books::ReaderNotFound, Books::InvalidStatusChange do |error|
    redirect_to book_path(params[:book_serial_number]), alert: error.message
  end

  def update
    book = Books::App.new.change_status(
      params[:book_serial_number], status: params[:status], card_number: params[:card_number]
    )

    redirect_to book_path(book.serial_number), notice: book.status == :borrowed ? "Book was lent." : "Book was returned."
  end
end
