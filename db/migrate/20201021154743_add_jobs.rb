# frozen_string_literal: true

class AddJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :jobs do |t|
      t.string :name
    end

    create_table :pipelines do |t|
      t.string :resource_id
      t.string :sha
      t.string :ref
      t.string :status
      t.string :web_url
      t.datetime :updated_at
      t.datetime :created_at
    end

    create_table :job_runs do |t|
      t.string :resource_id
      t.string :status
      t.string :stage
      t.string :ref
      t.datetime :created_at
      t.datetime :started_at
      t.datetime :finished_at
      t.integer :duration

      t.string :job_id
      t.string :pipeline_id
    end

    create_table :job_day_statistics do |t|
      t.string :job_id, null: false
      t.date :created_date, null: false
      t.integer :success_count, default: 0
      t.integer :failed_count, default: 0
    end

    add_foreign_key :job_runs, :jobs
    add_foreign_key :job_runs, :pipelines
    add_index :jobs, :name
    add_index :job_day_statistics, %i[created_date job_id], unique: true
    add_foreign_key :job_day_statistics, :jobs
  end
end
