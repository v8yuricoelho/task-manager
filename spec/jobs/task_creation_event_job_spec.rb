# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe TaskCreationEventJob, type: :worker do
  let(:task) { create(:task) }

  context 'when task is valid' do
    it 'queues the job correctly by invoking perform_async' do
      expect(TaskCreationEventJob).to receive(:perform_async).with(any_args)

      TaskCreationEventJob.perform_async({ 'task_id' => task.id }.to_json)
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

      TaskCreationEventJob.new.perform(nil, { 'task_id' => task.id }.to_json)
    end
  end

  context 'when there is a failure' do
    it 'raises an error if task is not found' do
      expect do
        TaskCreationEventJob.new.perform(nil, { 'task_id' => nil }.to_json)
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'logs an error when SQS fails' do
      sqs_client = double(Aws::SQS::Client)
      allow(Aws::SQS::Client).to receive(:new).and_return(sqs_client)
      allow(sqs_client).to receive(:send_message).and_raise(Aws::SQS::Errors::ServiceError.new(nil, 'Error'))

      expect(Rails.logger).to receive(:error).with('Failed to send message to SQS: Error')

      TaskCreationEventJob.new.perform(nil, { 'task_id' => task.id }.to_json)
    end
  end
end
# rubocop:enable Metrics/BlockLength
