# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :token, :access_level
end
