module Readers
  class Repository
    def all
      Reader.order(:full_name).map { |reader| ReaderSummary.new(card_number: reader.card_number, full_name: reader.full_name) }
    end
  end
end
