# frozen_string_literal: true

require 'app/main'

module APIHelpers
  def app
    API::Main
  end

  def use_auth_header(token)
    header 'Authentication', "Token #{token}"
  end

  def json_response
    @_json_response ||= JSON.parse(last_response.body, symbolize_names: true)
  end
end
