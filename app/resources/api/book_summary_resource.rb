module Api
  class BookSummaryResource
    include Alba::Resource

    root_key :book, :books

    attributes :serial_number, :title, :author, :status
  end
end
