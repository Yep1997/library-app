class SendReturnRemindersJob < ApplicationJob
  queue_as :default

  def perform
    Books::App.new.send_return_reminders
  end
end
