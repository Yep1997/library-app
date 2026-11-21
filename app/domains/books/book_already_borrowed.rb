module Books
  class BookAlreadyBorrowed < StandardError
    def initialize(serial_number)
      super("Book #{serial_number} is already borrowed")
    end
  end
end
