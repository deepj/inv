# frozen_string_literal: true

class AccessSerializer < ActiveModel::Serializer
  attribute :id, :level, :starts_at, :ends_at
end
