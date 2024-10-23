# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :authenticate_user!

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user_id

    if @task.save
      TaskCreationEventJob.perform_async(@task.id)
      redirect_to tasks_path, notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  def index
    @tasks = Task.where(user_id: current_user_id)
  end

  def show
    @task = Task.find(params[:id])
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path, notice: 'Task was successfully deleted.'
  end

  private

  def task_params
    params.require(:task).permit(:url, :status)
  end
end
