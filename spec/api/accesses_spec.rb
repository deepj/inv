# frozen_string_literal: true

require 'app/accesses'

RSpec.describe API::Accesses, type: :request do
  describe 'GET /accesses' do
    let(:user)     { create(:user) }
    let(:access_1) { create(:access, user: user, starts_at: 1.hour.ago, level: 10) }
    let(:access_2) { create(:access, user: user, level: 30) }
    let(:accesses) { [access_1, access_2] }

    context 'when a user is authenticated using a valid token' do
      before do
        create_access!
        authentication_token!(user.token)
        get '/accesses'
      end

      it 'returns the correct response' do
        expect(last_response).to have_status_code(200)
        expect(last_response).to have_content_type('application/json')
        expect(last_response).to match_json_schema('access')
      end

      it 'returns all accesses' do
        expect(json_response).to include(accesses: an_object_matching([
                                                                        a_hash_including(id: access_2.id, level: 30),
                                                                        a_hash_including(id: access_1.id, level: 10)
                                                                      ]))
      end

      context 'when there are no accesses available' do
        let(:accesses) { [] }

        it 'returns a empty collection of accesses' do
          expect(json_response).to include(accesses: [])
        end
      end
    end

    context 'when a user is not authenticated' do
      before { get '/accesses' }

      it 'returns the error response' do
        expect(last_response).to have_status_code(401)
        expect(last_response).to have_content_type('application/json')
        expect(last_response).to be_error.with_message('Unauthorized')
      end
    end
  end

  describe 'POST /accesses' do
    subject(:request) { post '/accesses', params.to_json }

    let(:user)     { create(:user) }
    let(:access_1) { create(:access, user: user, starts_at: 1.hour.ago, level: 10) }
    let(:access_2) { create(:access, user: user, starts_at: 30.minutes.ago, level: 30) }
    let(:accesses) { [access_1, access_2] }
    let(:params) do
      { access: { level: 333, starts_at: 1.minute.ago.iso8601, ends_at: 30.seconds.ago.iso8601 } }
    end

    before { javascript_content_type! }

    context 'when a user is authenticated using a valid token' do
      before do
        create_access!
        authentication_token!(user.token)
        expect { request }.to change { Access.count }.by(1)
      end

      it 'returns the correct response' do
        expect(last_response).to have_status_code(201)
        expect(last_response).to have_content_type('application/json')
        expect(last_response).to match_json_schema('access')
      end

      it 'returns the latest accesses' do
        expect(json_response).to include(accesses: an_object_matching([
                                                                        a_hash_including(level: 333),
                                                                        a_hash_including(level: 30),
                                                                        a_hash_including(level: 10)
                                                                      ]))
      end
    end

    context 'when a user is not authenticated' do
      before { create_access! }

      it 'returns the error response' do
        expect { request }.not_to change { Access.count }
        expect(last_response).to have_status_code(401)
        expect(last_response).to have_content_type('application/json')
        expect(last_response).to be_error.with_message('Unauthorized')
      end
    end

    context 'when params are not valid' do
      let(:params) { [] }

      before do
        create_access!
        authentication_token!(user.token)
      end

      it 'returns the error response' do
        expect { request }.not_to change { Access.count }
        expect(last_response).to have_status_code(422)
        expect(last_response).to have_content_type('application/json')
        expect(json_response).to include(error:
                                   a_hash_including(details:
                                     a_hash_including(level: an_object_matching(['level is missing', 'level must be greater than 0']),
                                                      starts_at: an_object_matching(['starts_at is missing']))))
      end
    end
  end

  describe 'DELETE /accesses/:id' do
    subject(:request) { delete "/accesses/#{current_access_id}" }

    let(:user)              { create(:user) }
    let(:access_1)          { create(:access, user: user, starts_at: 1.hour.ago, level: 10) }
    let(:access_2)          { create(:access, user: user, starts_at: 30.minutes.ago, level: 30) }
    let(:access_3)          { create(:access, user: user, starts_at: 1.hour.ago, level: 10) }
    let(:access_4)          { create(:access, starts_at: 30.minutes.ago, level: 30) }
    let(:accesses)          { [access_1, access_2, access_3, access_4] }
    let(:current_access_id) { access_3.id }

    before { javascript_content_type! }

    context 'when a user is authenticated using a valid token' do
      before do
        create_access!
        authentication_token!(user.token)
        expect { request }.to change { Access.count }.by(-1)
      end

      it 'returns the correct response' do
        expect(last_response).to have_status_code(204)
        expect(last_response).not_to have_content_type
        expect(last_response).not_to have_body
      end
    end

    context 'when a user is not authenticated' do
      before { create_access! }

      it 'returns the error response' do
        expect { request }.not_to change { Access.count }
        expect(last_response).to have_status_code(401)
        expect(last_response).to have_content_type('application/json')
        expect(last_response).to be_error.with_message('Unauthorized')
      end
    end

    context 'when an given access is not available' do
      let(:current_access_id) { 999_999_998 }

      before do
        create_access!
        authentication_token!(user.token)
        expect { request }.not_to change { Access.count }
      end

      it 'returns the error response' do
        expect(last_response).to have_status_code(404)
        expect(last_response).to have_content_type('application/json')
        expect(last_response).to be_error.with_message('Not found')
      end
    end

    context 'when an given access does not belong to a given user' do
      let(:current_access_id) { access_4.id }
      let(:accesses)          { [access_4] }

      before do
        create_access!
        authentication_token!(user.token)
        expect { request }.not_to change { Access.count }
      end

      it 'returns the error response' do
        expect(last_response).to have_status_code(404)
        expect(last_response).to have_content_type('application/json')
        expect(last_response).to be_error.with_message('Not found')
      end
    end
  end

  private

  def create_access!
    accesses
    nil
  end
end
