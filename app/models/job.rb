# frozen_string_literal: true

# == Schema Information
#
# Table name: jobs
#
#  id   :integer          not null, primary key
#  name :string
#
class Job < ApplicationRecord
  has_many :job_run
  has_many :job_day_statistics, class_name: 'JobDayStatistics'

  BRANCH = 'master'

  def calculate_success_rate
    job_runs_master = job_run.where(ref: BRANCH)

    total = job_runs_master.count
    successes = job_runs_master.where(status: 'success').count
    failures = job_runs_master.where(status: 'failed').count

    puts successes.to_f / total
    puts failures.to_f / total
  end
end
