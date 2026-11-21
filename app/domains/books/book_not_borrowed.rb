module Books
  class BookNotBorrowed < StandardError
    def initialize(serial_number)
      super("Book #{serial_number} is not borrowed")
    end
  end
end
