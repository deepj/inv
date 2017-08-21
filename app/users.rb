# frozen_string_literal: true

require 'grape'

module API
  class Users < Grape::API
    get :user do
      # Your code here
    end

    resource :users do
      post do
        # Your code here
      end
    end
  end
end
