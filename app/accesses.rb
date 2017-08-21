# frozen_string_literal: true

require 'grape'

module API
  class Accesses < Grape::API
    resource 'accesses' do
      get do
        # Your code here
      end

      post do
        # Your code here
      end

      namespace :id do
        delete do
          # Your code here
        end
      end
    end
  end
end
