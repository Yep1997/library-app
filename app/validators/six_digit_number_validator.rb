class SixDigitNumberValidator < ActiveModel::EachValidator
  FORMAT = /\A\d{6}\z/

  def validate_each(record, attribute, value)
    record.errors.add(attribute, :six_digit_number) unless FORMAT.match?(value.to_s)
  end
end
