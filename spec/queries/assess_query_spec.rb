# frozen_string_literal: true

require 'app/models/access'
require 'app/queries/access_query'

RSpec.describe AccessQuery, type: :query do
  subject(:result) { relation.to_a }

  let(:user_1)   { create(:user) }
  let(:user_2)   { create(:user) }
  let(:user_3)   { create(:user) }
  let(:user_4)   { create(:user) }
  let(:relation) { described_class.relation }

  let(:current_time)      { Time.current }
  let(:five_seconds_ago)  { 5.seconds.ago }
  let(:two_hours_ago)     { 2.hours.ago }
  let(:one_hour_from_now) { 1.hour.from_now }
  let(:one_hour_ago)      { 1.hour.ago }

  let(:access_1) { create(:access, user: user_1, starts_at: five_seconds_ago, level: 5) }
  let(:access_2) { create(:access, user: user_1, starts_at: five_seconds_ago, level: 3) }
  let(:access_3) { create(:access, user: user_1, starts_at: one_hour_ago, level: 10) }
  let(:access_4) { create(:access, user: user_1, starts_at: one_hour_from_now, level: 3) }
  let(:access_5) { create(:access, user: user_2, starts_at: five_seconds_ago, level: 3) }
  let(:access_6) { create(:access, user: user_3, starts_at: current_time) }
  let(:access_7) { create(:access, user: user_4, starts_at: two_hours_ago, level: 88) }
  let(:access_8) { create(:access, user: user_4, starts_at: two_hours_ago, level: 77) }

  let(:accesses) { [access_1, access_2, access_3, access_4, access_5, access_6, access_7, access_8] }

  before { create_access! }

  it 'returns all accesses ordered by stars_at and level in descending order' do
    expect(result).to all(be_a(Access))
    expect(result).to match([
                              an_object_having_attributes(id: access_4.id),
                              an_object_having_attributes(id: access_6.id),
                              an_object_having_attributes(id: access_1.id),
                              an_object_having_attributes(id: access_5.id),
                              an_object_having_attributes(id: access_2.id),
                              an_object_having_attributes(id: access_3.id),
                              an_object_having_attributes(id: access_7.id),
                              an_object_having_attributes(id: access_8.id)
                            ])
  end

  context 'with a specific relation' do
    let(:relation) { described_class.new(Access.where(id: access_7.id)).relation }

    it 'returns a specific records given by its id' do
      expect(result).to all(be_a(Access))
      expect(result).to match([an_object_having_attributes(id: access_7.id)])
    end

    context 'when there is no given id' do
      let(:relation) { described_class.new(Access.where(id: 99_999_999)).relation }

      it 'returns the empty result' do
        expect(result).to be_empty
      end
    end
  end

  context 'by given user scope' do
    let(:relation) { described_class.relation.by_given_user(user_4) }

    it 'returns all accesses of the given user ordered by stars_at and level in descending order' do
      expect(result).to all(be_a(Access))
      expect(result).to match([
                                an_object_having_attributes(id: access_7.id),
                                an_object_having_attributes(id: access_8.id)
                              ])
    end

    context 'when there is no access for the given user' do
      let(:accesses) { [] }

      it 'returns the empty result' do
        expect(result).to be_empty
      end
    end
  end

  private

  def create_access!
    accesses
    nil
  end
end
