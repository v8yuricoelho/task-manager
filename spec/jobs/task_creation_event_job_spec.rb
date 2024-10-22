# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

Sidekiq::Testing.fake!

# rubocop:disable Metrics/BlockLength
RSpec.describe TaskCreationEventJob, type: :worker do
  let(:task) { create(:task) }

  before do
    Sidekiq::Worker.clear_all
  end

  context 'when task is valid' do
    it 'queues the job correctly' do
      expect do
        TaskCreationEventJob.perform_async(task.id)
      end.to change(TaskCreationEventJob.jobs, :size).by(1)
    end

    it 'sends the correct message to SQS' do
      sqs_client = double(Aws::SQS::Client)
      allow(Aws::SQS::Client).to receive(:new).and_return(sqs_client)

      expect(sqs_client).to receive(:send_message).with(
        hash_including(
          queue_url: ENV['SQS_QUEUE_URL'],
          message_body: anything
        )
      )

      TaskCreationEventJob.new.perform(task.id)
    end
  end

  context 'when there is a failure' do
    it 'raises an error if task is not found' do
      expect do
        TaskCreationEventJob.new.perform(nil)
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'logs an error when SQS fails' do
      sqs_client = double(Aws::SQS::Client)
      allow(Aws::SQS::Client).to receive(:new).and_return(sqs_client)
      allow(sqs_client).to receive(:send_message).and_raise(Aws::SQS::Errors::ServiceError.new(nil, 'Error'))

      expect(Rails.logger).to receive(:error).with('Failed to send message to SQS: Error')

      TaskCreationEventJob.new.perform(task.id)
    end
  end
end
# rubocop:enable Metrics/BlockLength
