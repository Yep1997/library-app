module Books
  LoanEntry = Data.define(:borrowed_at, :due_on, :returned_at, :borrower)
end
