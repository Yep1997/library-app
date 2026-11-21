module BookParams
  BOOK_ATTRIBUTES = %i[serial_number title author].freeze

  private

  def book_params
    attributes = params.expect(book: BOOK_ATTRIBUTES)
    BOOK_ATTRIBUTES.index_with { |attribute| attributes[attribute] }
  end
end
