# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskUpdateWorker, type: :worker do
  let(:task) { create(:task) }

  context 'when the task is successfully found and updated' do
    it 'updates the task status' do
      status_data = { 'task_id' => task.id, 'status' => 'completed' }.to_json

      expect(Task).to receive(:find_by).with(id: task.id).and_return(task)
      expect(task).to receive(:update!).with(status: 'completed')

      TaskUpdateWorker.new.perform(nil, status_data)
    end
  end

  context 'when the update fails' do
    it 'logs an error when update! raises an exception' do
      status_data = { 'task_id' => task.id, 'status' => 'completed' }.to_json

      allow(Task).to receive(:find_by).with(id: task.id).and_return(task)
      allow(task).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)

      expect(Rails.logger).to receive(:error).with("Failed to update task ##{task.id}: Record invalid")

      TaskUpdateWorker.new.perform(nil, status_data)
    end
  end
end
