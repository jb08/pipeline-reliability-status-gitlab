# frozen_string_literal: true

class AddProcessIndex < ActiveRecord::Migration[6.0]
  def change
    add_index :job_runs, :processed
  end
end
