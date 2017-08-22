# frozen_string_literal: true

require_relative 'application_record'
require_relative 'access'

class User < ApplicationRecord
  has_many :accesses
end
