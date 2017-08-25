# frozen_string_literal: true

require 'app/forms/user_form'

RSpec.describe UserForm, type: :form do
  subject(:form) { UserForm.new }

  it 'saves a newly created user with a generated token' do
    expect { form.call }.to change { User.count }.by(1)
    expect(form.user).to be_persisted
    expect(form.user.token).not_to be_nil
    expect(form.user.token.length).to eq(64)
  end
end
