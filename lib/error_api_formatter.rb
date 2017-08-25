# frozen_string_literal: true

class ErrorAPIFormatter
  def self.call(message, _backtrace, _options, _env)
    response = message.is_a?(Hash) ? message : { error: { message: message } }
    ::Grape::Json.dump(response)
  end
end
