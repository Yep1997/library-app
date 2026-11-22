# Library App

A library management API built with Ruby on Rails and PostgreSQL, with a few simple HTML pages on top of the same domain code.

## Running the app

```sh
docker compose up
```

- App: http://localhost:3000
- Sent emails: http://localhost:3000/letter_opener
- Seeded reader card numbers: `100001`, `100002`, `100003`

Run the tests with:

```sh
docker compose run --rm web bin/rspec
```

## API

| Method | Path | Description |
| --- | --- | --- |
| `GET` | `/api/books` | List books with availability |
| `POST` | `/api/books` | Add a book |
| `GET` | `/api/books/:serial_number` | Show a book with its borrowing history |
| `DELETE` | `/api/books/:serial_number` | Delete a book |
| `PATCH` | `/api/books/:serial_number/status` | Mark a book as borrowed or available |

```sh
curl -X POST http://localhost:3000/api/books \
  -H "Content-Type: application/json" \
  -d '{"book":{"serial_number":"654321","title":"Refactoring","author":"Martin Fowler"}}'

curl -X PATCH http://localhost:3000/api/books/654321/status \
  -H "Content-Type: application/json" \
  -d '{"status":"borrowed","card_number":"100001"}'

curl -X PATCH http://localhost:3000/api/books/654321/status \
  -H "Content-Type: application/json" \
  -d '{"status":"available"}'
```

## Return reminders

Loans last 30 days. An hourly Solid Queue job emails readers 3 days before the due date and on the due date. Each reminder is recorded on the loan, so it is sent only once.

To trigger a reminder for the latest active loan:

```sh
docker compose exec web bin/rails runner \
  'Loan.active.last.update!(due_on: Date.current + 3); SendReturnRemindersJob.perform_later'
```

## Design decisions

- **Domain layer:** business code lives in `app/domains`. Controllers and jobs use only the public `Books::App` entry point.
- **Clear responsibilities:** services hold business rules, the repository handles persistence, and controllers only translate HTTP.
- **Loans as the source of truth:** a book is borrowed when it has a loan without `returned_at`, so status and history cannot drift apart.
- **Integrity in the database:** unique indexes protect identifiers, and a partial unique index allows only one active loan per book.
- **Solid Queue:** background jobs run on PostgreSQL, so the project needs no Redis.

## Limitations

- There is no authentication, and readers are created only through seeds.
- Book lists have no pagination or search.
- Deleting a book also deletes its borrowing history, even while it is borrowed.
- Dates use UTC, so "today" can differ from the library's local date around midnight.
- The Docker setup targets development and is not production-ready.
- Malformed API requests receive an HTML `400` response instead of JSON.
