# frozen_string_literal: true

require 'grape'

require 'app/queries/access_query'
require 'app/serializers/access_serializer'
require 'app/forms/access_form'

module API
  class Accesses < Grape::API
    resource 'accesses' do
      get do
        authenticate!

        AccessQuery.relation.by_given_user(current_user)
      end

      post do
        authenticate!
        access_form = AccessForm.new(params[:access], user: current_user)
        access_form.call
        error!({ error: { message: 'Unprocessable Entity', details: access_form.error_messages } }, 422) if access_form.fail?
        AccessQuery.relation.by_given_user(current_user)
      end

      delete ':id', requirements: { id: /[0-9]*/ } do
        authenticate!

        access = AccessQuery.relation(Access.where(id: params[:id])).by_given_user(current_user).take
        error!('Not found', 404) unless access
        access.destroy
        status(204)
      end
    end
  end
end
