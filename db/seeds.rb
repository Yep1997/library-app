[
  { card_number: "100001", full_name: "Anna Kowalska", email: "anna.kowalska@example.com" },
  { card_number: "100002", full_name: "Jan Nowak", email: "jan.nowak@example.com" },
  { card_number: "100003", full_name: "Maria Wiśniewska", email: "maria.wisniewska@example.com" }
].each do |attributes|
  Reader.find_or_create_by!(card_number: attributes[:card_number]) do |reader|
    reader.assign_attributes(attributes)
  end
end
