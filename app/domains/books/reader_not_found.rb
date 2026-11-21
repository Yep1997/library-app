module Books
  class ReaderNotFound < StandardError
    def initialize(card_number)
      super("Reader #{card_number} not found")
    end
  end
end
