require "rails_helper"

RSpec.describe SendReturnRemindersJob, type: :job do
  it "sends reminders for books due today" do
    loan = create(:loan, due_on: Date.current)

    expect { described_class.perform_now }
      .to have_enqueued_mail(LoanReminderMailer, :due_today).with(params: { loan: }, args: [])
  end
end
