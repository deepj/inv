# frozen_string_literal: true

AccessSchema = Dry::Validation.JSON do
  required(:level).filled(:int?, gt?: 0)
  required(:starts_at).filled(:date_time?)
  optional(:ends_at).maybe(:date_time?)
end
