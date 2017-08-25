# frozen_string_literal: true

require 'app/models/user'

class UserWithAccessLevelQuery
  def initialize(relation = User.all)
    @relation = relation.extending(Scopes)
  end

  def self.relation
    new.relation
  end

  def relation
    @relation.select('"users".*, "access"."level" AS "access_level"')
             .from(%{"users", LATERAL (#{access_sub_select.to_sql}) access})
  end

  module Scopes
    def by_given_user(user)
      where(id: user.id)
    end
  end

  private

  def accesses_per_group
    Access.select('"accesses".*, RANK() OVER(PARTITION BY "accesses"."user_id", ' \
                  '"accesses"."starts_at" ORDER BY "accesses"."level" DESC)')
          .order(starts_at: :desc)
  end

  def access_sub_select
    Access.select('"access_sub_select".*')
          .from(accesses_per_group, :access_sub_select)
          .where('"access_sub_select"."rank" = 1')
          .where('"access_sub_select"."user_id" = "users"."id"')
          .limit(1)
  end
end
