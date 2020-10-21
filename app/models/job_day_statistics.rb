# frozen_string_literal: true

# == Schema Information
#
# Table name: job_day_statistics
#
#  id            :integer          not null, primary key
#  job_id        :string           not null
#  created_date  :date             not null
#  success_count :integer          default(0)
#  failed_count  :integer          default(0)
#
class JobDayStatistics < ApplicationRecord
  belongs_to :job

  validates :created_date, uniqueness: { scope: :job_id }

  def success_rate
    total = success_count + failed_count

    return '-' if total.zero?

    percentage = ((success_count.to_f / total) * 100).to_i
    "#{percentage}%"
  end

  def self.oldest_date
    JobDayStatistics.pluck(:created_date).min
  end

  def self.most_recent_date
    JobDayStatistics.pluck(:created_date).max
  end
end
