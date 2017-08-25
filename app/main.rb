# frozen_string_literal: true

require 'grape'

require_relative 'users'
require_relative 'accesses'
require 'lib/error_api_formatter'

module API
  class Main < Grape::API
    default_format :json
    format :json
    formatter :json, Grape::Formatter::ActiveModelSerializers
    error_formatter :json, ErrorAPIFormatter

    helpers do
      def current_user
        @_current_user ||= User.find_by(token: authentication_token)
      end

      def authenticate!
        error!('Unauthorized', 401) unless current_user
      end

      def authentication_token
        headers['Authentication'].to_s[6..69]
      end
    end

    mount Users
    mount Accesses

    route :any, '*path' do
      error!('Not found', 404)
    end
  end
end
