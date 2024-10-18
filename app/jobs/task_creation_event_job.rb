# frozen_string_literal: true

class TaskCreationEventJob
  include Sidekiq::Worker
  sidekiq_options queue: 'tasks_queue'

  def perform(task_id)
    task = Task.find(task_id)

    message_body = {
      task_id: task.id,
      user_id: task.user_id,
      status: task.status,
      url: task.url
    }.to_json

    send_to_sqs(message_body)
  end

  private

  def send_to_sqs(message_body)
    sqs_client = Aws::SQS::Client.new(region: ENV['AWS_REGION'])

    sqs_client.send_message({
                              queue_url: ENV['SQS_QUEUE_URL'],
                              message_body: message_body
                            })
  rescue Aws::SQS::Errors::ServiceError => e
    Rails.logger.error("Failed to send message to SQS: #{e.message}")
  end
end
