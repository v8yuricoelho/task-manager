# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:user_id) }
    it {
      should define_enum_for(:status)
        .with_values(pending: 0, in_progress: 1, completed: 2, failed: 3)
    }
  end
end
