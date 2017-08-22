# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |table|
      table.string :token, limit: 64, index: true, unique: true, null: false
    end
  end
end
