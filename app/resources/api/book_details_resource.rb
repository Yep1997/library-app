module Api
  class BookDetailsResource
    include Alba::Resource

    root_key :book

    attributes :serial_number, :title, :author, :status
    many :loans, resource: LoanResource
  end
end
