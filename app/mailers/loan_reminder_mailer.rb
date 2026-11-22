class LoanReminderMailer < ApplicationMailer
  helper_method :loan

  def due_soon
    mail(to: loan.reader.email, subject: "#{loan.book.title} is due soon")
  end

  private

  def loan
    params.fetch(:loan)
  end
end
