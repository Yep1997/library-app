FactoryBot.define do
  factory :loan do
    book
    reader
    borrowed_at { Time.current }
    due_on { borrowed_at.to_date + 30 }

    trait :returned do
      returned_at { borrowed_at + 1.day }
    end
  end
end
