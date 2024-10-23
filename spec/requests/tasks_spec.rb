# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  let!(:task) { create(:task) }
  let(:valid_attributes) { attributes_for(:task) }
  let(:invalid_attributes) { { url: '', status: '' } }

  describe 'GET /index' do
    it 'renders a successful response' do
      get tasks_path
      expect(response).to be_successful
    end
  end

  describe 'GET /show/:id' do
    it 'renders a successful response' do
      get task_path(task)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new task' do
        expect do
          post tasks_path, params: { task: valid_attributes }
        end.to change(Task, :count).by(1)
      end

      it 'redirects to the tasks list' do
        post tasks_path, params: { task: valid_attributes }
        expect(response).to redirect_to(tasks_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new task' do
        expect do
          post tasks_path, params: { task: invalid_attributes }
        end.to change(Task, :count).by(0)
      end

      it 'renders the new template' do
        post tasks_path, params: { task: invalid_attributes }
        expect(response.body).to include('error')
      end
    end
  end

  describe 'DELETE /destroy/:id' do
    it 'deletes the task and redirects to index' do
      expect do
        delete task_path(task)
      end.to change(Task, :count).by(-1)
      expect(response).to redirect_to(tasks_path)
    end
  end
end
