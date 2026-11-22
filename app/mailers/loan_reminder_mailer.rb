class LoanReminderMailer < ApplicationMailer
  helper_method :loan

  def due_soon
    mail(to: loan.reader.email, subject: "#{loan.book.title} is due soon")
  end

  def due_today
    mail(to: loan.reader.email, subject: "#{loan.book.title} is due today")
  end

  private

  def loan
    params.fetch(:loan)
  end
end
