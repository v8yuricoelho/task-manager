# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    url { Faker::Internet.url }
    status { %w[pending in_progress completed failed].sample }
  end
end
