# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :authenticate_user!

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user_id

    if @task.save
      TaskCreationEventJob.perform_async(@task.id)
      render json: @task, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def index
    @tasks = Task.where(user_id: current_user_id)
  end

  private

  def task_params
    params.require(:task).permit(:url, :status)
  end
end
