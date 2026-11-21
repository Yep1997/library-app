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
