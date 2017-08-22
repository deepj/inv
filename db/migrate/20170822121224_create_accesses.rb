# frozen_string_literal: true

class CreateAccesses < ActiveRecord::Migration[5.1]
  def change
    create_table :accesses do |table|
      table.references :user,      foreign_key: true
      table.integer    :level,     index: true, null: false
      table.datetime   :starts_at, null: false
      table.datetime   :ends_at
    end
  end
end
