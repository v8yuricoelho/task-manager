# frozen_string_literal: true

class TasksController < ApplicationController
  def create
    @task = Task.new(task_params)
    @task.user_id = current_user_id

    if @task.save
      render json: @task, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  private

  def task_params
    params.require(:task).permit(:url, :status)
  end
end
