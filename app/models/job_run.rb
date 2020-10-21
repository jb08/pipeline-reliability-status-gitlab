# frozen_string_literal: true

# == Schema Information
#
# Table name: job_runs
#
#  id          :integer          not null, primary key
#  resource_id :string
#  status      :string
#  stage       :string
#  ref         :string
#  created_at  :datetime
#  started_at  :datetime
#  finished_at :datetime
#  duration    :integer
#  job_id      :string
#  pipeline_id :string
#
class JobRun < ApplicationRecord
  belongs_to :job
  belongs_to :pipeline

  SUCCESS = 'success'
  FAILED = 'failed'

  validates :status, inclusion: { in: [SUCCESS, FAILED] }

  def created_date
    created_at.to_date
  end
end
