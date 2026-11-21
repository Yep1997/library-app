module Books
  class BookNotFound < StandardError
    def initialize(serial_number)
      super("Book #{serial_number} not found")
    end
  end
end
