module Books
  class ChangeStatus
    STATUSES = %w[borrowed available].freeze

    def initialize(repository:)
      @repository = repository
    end

    def call(serial_number, status:, card_number: nil)
      raise InvalidStatusChange, "Status must be one of: #{STATUSES.join(", ")}" unless status.to_s.in?(STATUSES)

      book = repository.find_book(serial_number)
      status.to_s == "borrowed" ? borrow(book, card_number) : return_book(book)
      repository.find_summary(serial_number)
    end

    private

    attr_reader :repository

    def borrow(book, card_number)
      raise InvalidStatusChange, "Card number is required to borrow a book" if card_number.blank?
      raise BookAlreadyBorrowed, book.serial_number if book.active_loan

      reader = repository.find_reader(card_number)
      repository.create_loan(book:, reader:, borrowed_at: Time.current, due_on: Date.current + LOAN_PERIOD)
    end

    def return_book(book)
      raise BookNotBorrowed, book.serial_number unless book.active_loan

      repository.close_loan(book.active_loan, returned_at: Time.current)
    end
  end
end
