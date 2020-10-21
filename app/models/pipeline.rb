# frozen_string_literal: true

# == Schema Information
#
# Table name: pipelines
#
#  id          :integer          not null, primary key
#  resource_id :string
#  sha         :string
#  ref         :string
#  status      :string
#  web_url     :string
#  updated_at  :datetime
#  created_at  :datetime
#
class Pipeline < ApplicationRecord
  has_many :job_run
end
