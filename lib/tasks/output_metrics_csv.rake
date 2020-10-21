# frozen_string_literal: true

desc 'output pipeline reliability metrics'

task :output_metrics_csv, [] do |_t, _args|
  JobRun.all.each do |job_run|
    date_job_stat = JobDayStatistics.find_or_create_by!(job_id: job_run.job.id,
                                                        created_date: job_run.created_date)

    date_job_stat.increment!(:success_count) if job_run.status == JobRun::SUCCESS
    date_job_stat.increment!(:failed_count) if job_run.status == JobRun::FAILED
  end

  filename = 'job_reliability_stats_output.csv'
  CSV.open(filename, 'w') do |csv|
    oldest_date = JobDayStatistics.oldest_date
    most_recent_date = JobDayStatistics.most_recent_date
    csv << ['job_name'].concat((oldest_date..most_recent_date).to_a)

    Job.all.sort_by(&:name).each do |job|
      job_stats_output = "#{job.name} ,"

      (oldest_date..most_recent_date).each do |day|
        js = JobDayStatistics.find_by(job_id: job.id, created_date: day)
        job_stats_output << "#{js&.success_rate} ,"
      end
      csv << [job_stats_output]
    end
  end
  puts "Pipeline reliability metrics outputed to #{filename}"
end
