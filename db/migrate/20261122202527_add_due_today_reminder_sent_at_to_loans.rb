class AddDueTodayReminderSentAtToLoans < ActiveRecord::Migration[8.1]
  def change
    add_column :loans, :due_today_reminder_sent_at, :datetime
  end
end
