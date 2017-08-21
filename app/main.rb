# frozen_string_literal: true

require 'grape'

require_relative 'users'
require_relative 'accesses'

module API
  class Main < Grape::API
    mount Users
    mount Accesses
  end
end
