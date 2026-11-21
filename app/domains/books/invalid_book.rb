module Books
  class InvalidBook < StandardError
    attr_reader :errors

    def initialize(errors)
      @errors = errors
      super("Book is invalid")
    end
  end
end
