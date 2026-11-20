module Books
  class Repository
    def all
      Book.strict_loading.includes(:active_loan).order(:serial_number).map { |book| to_summary(book) }
    end

    private

    def to_summary(book)
      BookSummary.new(
        serial_number: book.serial_number,
        title: book.title,
        author: book.author,
        status: book.active_loan ? :borrowed : :available
      )
    end
  end
end
