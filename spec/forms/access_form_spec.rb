# frozen_string_literal: true

require 'app/models/access'
require 'app/forms/access_form'

RSpec.describe AccessForm, type: :form do
  subject(:access) { form.access }

  let(:user)          { create(:user) }
  let(:form)          { AccessForm.new(access_params, user: user) }
  let(:access_params) do
    { level: 333, starts_at: 1.minute.ago.iso8601, ends_at: 30.seconds.ago.iso8601 }
  end

  it 'creates a new access for the given user' do
    expect { form.call }.to change { Access.count }.by(1)
    expect(form).to have_attributes(error_messages: {})
  end

  context 'when params are invalid' do
    let(:access_params) { [] }

    it 'does not create access for the given user' do
      expect { form.call }.not_to change { Access.count }
      expect(form).to have_attributes(error_messages:
                                        a_hash_including(level: an_object_matching(['level is missing', 'level must be greater than 0']),
                                                         starts_at: an_object_matching(['starts_at is missing'])))
    end
  end
end
