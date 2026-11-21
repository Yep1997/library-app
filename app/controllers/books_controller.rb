class BooksController < ApplicationController
  include BookParams

  def index
    @books = Books::App.list
  end

  def show
    @book = Books::App.find(params[:serial_number])
  end

  def new
    @attributes = {}
    @errors = {}
  end

  def create
    book = Books::App.add(**book_params)

    redirect_to book_path(book.serial_number), notice: "Book was added."
  rescue Books::InvalidBook => error
    @attributes = book_params
    @errors = error.errors
    render :new, status: :unprocessable_content
  end

  def destroy
    Books::App.remove(params[:serial_number])

    redirect_to books_path, notice: "Book was removed."
  end
end
