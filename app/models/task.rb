# frozen_string_literal: true

class Task < ApplicationRecord
  validates :url, presence: true
  validates :status, presence: true

  enum status: { pending: 0, in_progress: 1, completed: 2, failed: 3 }
end
