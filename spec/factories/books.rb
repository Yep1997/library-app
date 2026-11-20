FactoryBot.define do
  factory :book do
    sequence(:serial_number) { |n| format("%06d", n) }
    title { "The Pragmatic Programmer" }
    author { "Andrew Hunt, David Thomas" }
  end
end
