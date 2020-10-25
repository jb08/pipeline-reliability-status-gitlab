# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_201_025_221_843) do
  create_table 'job_day_statistics', force: :cascade do |t|
    t.string 'job_id', null: false
    t.date 'created_date', null: false
    t.integer 'success_count', default: 0
    t.integer 'failed_count', default: 0
    t.index %w[created_date job_id], name: 'index_job_day_statistics_on_created_date_and_job_id', unique: true
  end

  create_table 'job_runs', force: :cascade do |t|
    t.string 'resource_id'
    t.string 'status'
    t.string 'stage'
    t.string 'ref'
    t.datetime 'created_at'
    t.datetime 'started_at'
    t.datetime 'finished_at'
    t.integer 'duration'
    t.string 'job_id'
    t.string 'pipeline_id'
    t.boolean 'processed', default: false
    t.index ['processed'], name: 'index_job_runs_on_processed'
  end

  create_table 'jobs', force: :cascade do |t|
    t.string 'name'
    t.index ['name'], name: 'index_jobs_on_name'
  end

  create_table 'pipelines', force: :cascade do |t|
    t.string 'resource_id'
    t.string 'sha'
    t.string 'ref'
    t.string 'status'
    t.string 'web_url'
    t.datetime 'updated_at'
    t.datetime 'created_at'
  end

  add_foreign_key 'job_day_statistics', 'jobs'
  add_foreign_key 'job_runs', 'jobs'
  add_foreign_key 'job_runs', 'pipelines'
end
