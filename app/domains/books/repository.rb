module Books
  class Repository
    def all
      Book.strict_loading.includes(:active_loan).order(:serial_number).map { |book| to_summary(book) }
    end

    def find(serial_number)
      book = Book.strict_loading.includes(loans: :reader).find_by(serial_number:)
      raise BookNotFound, serial_number unless book

      to_details(book)
    end

    def create(attributes)
      book = Book.new(attributes)
      raise InvalidBook, book.errors.to_hash unless book.save

      to_summary(book)
    end

    def delete(serial_number)
      deleted_count = Book.where(serial_number:).delete_all
      raise BookNotFound, serial_number if deleted_count.zero?
    end

    def find_book(serial_number)
      Book.find_by(serial_number:) || raise(BookNotFound, serial_number)
    end

    def find_reader(card_number)
      Reader.find_by(card_number:) || raise(ReaderNotFound, card_number)
    end

    def find_summary(serial_number)
      to_summary(Book.strict_loading.includes(:active_loan).find_by!(serial_number:))
    end

    def create_loan(book:, reader:, borrowed_at:, due_on:)
      Loan.create!(book:, reader:, borrowed_at:, due_on:)
    rescue ActiveRecord::RecordNotUnique
      raise BookAlreadyBorrowed, book.serial_number
    end

    def close_loan(loan, returned_at:)
      loan.update!(returned_at:)
    end

    def loans_awaiting_due_soon_reminder(due_on:)
      Loan.active.strict_loading.includes(:book, :reader).where(due_on:, due_soon_reminder_sent_at: nil)
    end

    def mark_due_soon_reminder_sent(loan, sent_at:)
      loan.update!(due_soon_reminder_sent_at: sent_at)
    end

    private

    def to_summary(book)
      BookSummary.new(
        serial_number: book.serial_number,
        title: book.title,
        author: book.author,
        status: status(borrowed: book.active_loan.present?)
      )
    end

    def to_details(book)
      BookDetails.new(
        serial_number: book.serial_number,
        title: book.title,
        author: book.author,
        status: status(borrowed: book.loans.any?(&:active?)),
        loans: book.loans.sort_by(&:borrowed_at).reverse.map { |loan| to_loan_entry(loan) }
      )
    end

    def to_loan_entry(loan)
      LoanEntry.new(
        borrowed_at: loan.borrowed_at,
        due_on: loan.due_on,
        returned_at: loan.returned_at,
        borrower: Borrower.new(card_number: loan.reader.card_number, full_name: loan.reader.full_name, email: loan.reader.email)
      )
    end

    def status(borrowed:)
      borrowed ? :borrowed : :available
    end
  end
end
