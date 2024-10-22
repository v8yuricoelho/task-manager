# frozen_string_literal: true

class TaskUpdateWorker
  include Shoryuken::Worker

  shoryuken_options queue: 'status_updates_queue', auto_delete: true

  def perform(_sqs_msg, body)
    status_data = JSON.parse(body)
    task_id = status_data['task_id']
    status = status_data['status']

    task = Task.find_by(id: task_id)

    task.update!(status: status)
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Failed to update task ##{task.id}: #{e.message}")
  end
end
