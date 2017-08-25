# frozen_string_literal: true

class ApplicationForm
  extend Dry::Initializer

  attr_reader :error_messages

  def success?
    error_messages.blank?
  end

  def fail?
    !success?
  end

  private

  attr_writer :error_messages
end
