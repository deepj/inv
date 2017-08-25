# frozen_string_literal: true

require_relative 'application_form'

class UserForm < ApplicationForm
  attr_reader :user

  def initialize(user: User.new)
    @user = user
  end

  def call
    user.token = generate_token
    user.save!
  end

  private

  def generate_token
    loop do
      random_token = SecureRandom.hex(32)
      break random_token unless user.class.exists?(token: random_token)
    end
  end
end
