# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    url { Faker::Internet.url }
    status { %w[pending in_progress completed failed].sample }
    user_id { Faker::Number.between(from: 1, to: 100) }
  end
end
