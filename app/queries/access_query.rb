# frozen_string_literal: true

require 'app/models/user'

class AccessQuery
  def initialize(relation = Access.all)
    @relation = relation.extending(Scopes)
  end

  def self.relation(relation = Access.all)
    new(relation).relation
  end

  def relation
    @relation.order(starts_at: :desc, level: :desc)
  end

  module Scopes
    def by_given_user(user)
      where(user: user)
    end
  end
end
