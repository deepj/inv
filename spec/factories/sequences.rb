# frozen_string_literal: true

require 'securerandom'

FactoryBot.define do
  sequence(:user_id)   { |user_id| user_id }
  sequence(:access_id) { |access_id| access_id }
  sequence(:token)     { SecureRandom.hex(32) }
end
