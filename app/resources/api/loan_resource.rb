module Api
  class LoanResource
    include Alba::Resource

    attributes :borrowed_at, :due_on, :returned_at
    one :reader, source: proc { borrower }, resource: ReaderResource
  end
end
