class BooksController < ApplicationController
  def index
    @books = Books::App.list
  end
end
