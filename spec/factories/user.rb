# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    id    { generate :user_id }
    token { generate :token }

    trait :associations do
      transient { accesses_count(1) }

      after(:create) do |user, evaluator|
        create_list(:access, evaluator.accesses_count, user: user)
      end

      after(:build) do |user, evaluator|
        build_list(:access, evaluator.accesses_count, user: user)
      end
    end
  end
end
