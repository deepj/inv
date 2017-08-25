# frozen_string_literal: true

require 'app/users'

RSpec.describe API::Users, type: :request do
  describe 'GET /user' do
    let(:user) { create(:user, :associations) }

    context 'when a user is authenticated using a valid token' do
      before do
        authentication_token user.token
        get '/user'
      end

      it 'returns the corrent response' do
        expect(last_response).to have_status_code(200)
        expect(last_response).to have_content_type('application/json')
        expect(last_response).to match_json_schema('user')
      end

      it 'returns the user response' do
        expect(json_response).to include(user: a_hash_including(access_level: 1))
      end
    end

    context 'when a user is not authenticated' do
      before { get '/user' }

      it 'returns the error response' do
        expect(last_response).to have_status_code(401)
        expect(last_response).to have_content_type('application/json')
        expect(last_response).to be_error.with_message('Unauthorized')
      end
    end
  end

  describe 'POST /users' do
    subject(:request) { post '/users' }

    before { expect { request }.to change { User.count }.by(1) }

    it 'returns the corrent response' do
      expect(last_response).to have_status_code(201)
      expect(last_response).to have_content_type('application/json')
      expect(last_response).to match_json_schema('user')
    end

    it 'returns a newly created user response' do
      expect(json_response).to include(user: a_hash_including(access_level: 0))
    end
  end
end
