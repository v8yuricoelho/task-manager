# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.integer :status, null: false, default: 0
      t.string :url, null: false

      t.timestamps
    end
  end
end
