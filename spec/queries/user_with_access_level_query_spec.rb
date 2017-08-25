# frozen_string_literal: true

require 'app/models/user'
require 'app/queries/user_with_access_level_query'

RSpec.describe UserWithAccessLevelQuery, type: :query do
  subject(:result) { relation.to_a }

  let(:user)                   { create(:user) }
  let(:other_user)             { create(:user) }
  let(:same_access_time)       { 5.seconds.ago }
  let(:other_same_access_time) { 2.hours.ago }
  let(:relation)               { UserWithAccessLevelQuery.relation }

  let(:access_1) { create(:access, user: user, starts_at: same_access_time, level: 5) }
  let(:access_2) { create(:access, user: user, starts_at: same_access_time, level: 3) }
  let(:access_3) { create(:access, user: user, starts_at: 1.hour.ago, level: 10) }
  let(:access_4) { create(:access, user: user, starts_at: 1.hour.from_now, level: 3) }
  let(:access_5) { create(:access, :associations, starts_at: same_access_time, level: 3) }
  let(:access_6) { create(:access, :associations) }
  let(:access_7) { create(:access, user: other_user, starts_at: other_same_access_time, level: 88) }
  let(:access_8) { create(:access, user: other_user, starts_at: other_same_access_time, level: 77) }

  let(:accesses) { [access_1, access_2, access_3, access_4, access_5, access_6, access_7, access_8] }

  before { create_access! }

  it 'returns all users with their calculated access levels per se' do
    expect(result).to all(be_a(User))
    expect(result).to match([
                              an_object_having_attributes(id: user.id, access_level: 3),
                              an_object_having_attributes(id: access_5.user.id, access_level: 3),
                              an_object_having_attributes(id: access_6.user.id, access_level: 1),
                              an_object_having_attributes(id: other_user.id, access_level: 88)
                            ])
  end

  context 'by given user' do
    subject(:result) { relation.take }

    let(:accesses) { [access_1, access_2, access_3, access_5] }
    let(:relation) { UserWithAccessLevelQuery.relation.by_given_user(user) }

    it 'returns only the given user with the latest access ' do
      expect(result).to be_a(User)
      expect(result).to have_attributes(id: user.id, access_level: 5)
    end

    context 'when there is no access for the given user' do
      let(:accesses) { [] }

      it 'returns nil' do
        expect(result).to be_nil
      end
    end
  end

  private

  def create_access!
    accesses
    nil
  end
end
