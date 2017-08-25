# frozen_string_literal: true

FactoryGirl.define do
  factory :access do
    level     { 1 }
    starts_at { Time.current }

    trait :associations do
      association :user
    end
  end
end
