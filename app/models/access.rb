# frozen_string_literal: true

require_relative 'application_record'
require_relative 'user'

class Access < ApplicationRecord
  belongs_to :user
end
