# frozen_string_literal: true

require 'app/models/schemas/access_schema'

require_relative 'application_form'

class AccessForm < ApplicationForm
  attr_reader :access

  def initialize(access_params, user:)
    @access_params = access_params.is_a?(Hash) ? access_params : {}
    @access        = Access.new
    @schema        = AccessSchema
    @user          = user
  end

  def call
    validate!
    if success?
      access.assign_attributes(**valid_params.merge(user: user))
      access.save
    end
    nil
  end

  private

  attr_reader :schema, :user
  attr_accessor :access_params, :valid_params

  def validate!
    result              = schema.call(access_params)
    self.error_messages = result.messages(full: true)
    self.valid_params   = result.output.except(*error_messages.keys)
    nil
  end
end
