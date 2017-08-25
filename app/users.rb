# frozen_string_literal: true

require 'grape'

require 'models/user'
require 'forms/user_form'
require 'serializers/user_serializer'
require 'queries/user_with_access_level_query'

module API
  class Users < Grape::API
    get '/user' do
      authenticate!

      UserWithAccessLevelQuery.relation.by_given_user(current_user).first || current_user
    end

    resource :users do
      post do
        user_form = UserForm.new
        user_form.call
        user_form.user
      end
    end
  end
end
