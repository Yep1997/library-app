require "rails_helper"

RSpec.describe LoanReminderMailer, type: :mailer do
  let(:reader) { create(:reader, full_name: "Anna Kowalska", email: "anna@example.com") }
  let(:book) { create(:book, title: "Refactoring") }
  let(:loan) { create(:loan, book:, reader:, due_on: Date.new(2026, 12, 24)) }

  describe "#due_soon" do
    subject(:mail) { described_class.with(loan:).due_soon }

    it "is addressed to the borrower" do
      expect(mail.to).to eq([ "anna@example.com" ])
    end

    it "names the book in the subject" do
      expect(mail.subject).to eq("Refactoring is due soon")
    end

    it "tells the reader who they are, what to return and by when" do
      expect(mail.body.encoded).to include("Anna Kowalska", "Refactoring", "2026-12-24")
    end
  end

  describe "#due_today" do
    subject(:mail) { described_class.with(loan:).due_today }

    it "is addressed to the borrower" do
      expect(mail.to).to eq([ "anna@example.com" ])
    end

    it "names the book in the subject" do
      expect(mail.subject).to eq("Refactoring is due today")
    end

    it "tells the reader who they are and what to return today" do
      expect(mail.body.encoded).to include("Anna Kowalska", "Refactoring", "today")
    end
  end
end
