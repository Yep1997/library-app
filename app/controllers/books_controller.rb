class BooksController < ApplicationController
  def index
    @books = Books::App.list
  end

  def show
    @book = Books::App.find(params[:serial_number])
  end
end
