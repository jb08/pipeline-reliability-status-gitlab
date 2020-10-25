# frozen_string_literal: true

class AddJobRunProcessed < ActiveRecord::Migration[6.0]
  def change
    add_column :job_runs, :processed, :boolean, default: false
  end
end
