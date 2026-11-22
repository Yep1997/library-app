class LoanReminderMailerPreview < ActionMailer::Preview
  def due_soon
    LoanReminderMailer.with(loan: sample_loan(due_on: Date.current + 3)).due_soon
  end

  private

  def sample_loan(due_on:)
    Loan.new(
      book: Book.new(serial_number: "123456", title: "Refactoring", author: "Martin Fowler"),
      reader: Reader.new(card_number: "100001", full_name: "Anna Kowalska", email: "anna@example.com"),
      borrowed_at: due_on - Books::LOAN_PERIOD,
      due_on:
    )
  end
end
