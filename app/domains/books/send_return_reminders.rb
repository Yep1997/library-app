module Books
  class SendReturnReminders
    DUE_SOON_WINDOW = 3.days

    def initialize(repository:)
      @repository = repository
    end

    def call
      today = Date.current

      repository.loans_awaiting_due_soon_reminder(due_on: today.tomorrow..(today + DUE_SOON_WINDOW)).each do |loan|
        LoanReminderMailer.with(loan:).due_soon.deliver_later
        repository.mark_due_soon_reminder_sent(loan, sent_at: Time.current)
      end
    end

    private

    attr_reader :repository
  end
end
