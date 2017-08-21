# frozen_string_literal: true

require 'app/users'

RSpec.describe API::Users, type: :request do
  describe 'GET /users' do
    before do
      get '/users'
    end
  end
end
