# frozen_string_literal: true

class AddUserIdToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :user_id, :integer, null: false
  end
end
