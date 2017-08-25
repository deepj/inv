# frozen_string_literal: true

class AccessSerializer < ActiveModel::Serializer
  attributes :id, :level, :starts_at, :ends_at
end
