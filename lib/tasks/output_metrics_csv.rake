# frozen_string_literal: true

desc 'output pipeline reliability metrics'

task :output_metrics_csv, [] do |_t, _args|
  puts 'calculating job statistics'

  unprocessed_job_runs = JobRun.where(processed: false)
  puts "there are a total of #{unprocessed_job_runs.count} unprocessed job_runs"
  unprocessed_job_runs.each_with_index do |job_run, i|
    puts "computed stats for #{i} job_runs" if (i % 100).zero?

    date_job_stat = JobDayStatistics.find_or_create_by!(job_id: job_run.job.id,
                                                        created_date: job_run.created_date)

    date_job_stat.increment!(:success_count) if job_run.status == JobRun::SUCCESS
    date_job_stat.increment!(:failed_count) if job_run.status == JobRun::FAILED
    job_run.update!(processed: true)
  end
  puts 'done calculating job statistics'

  puts 'starting outputting pipeline reliability metrics'
  filename = 'job_reliability_stats_output.csv'
  CSV.open(filename, 'w') do |csv|
    oldest_date = JobDayStatistics.oldest_date
    most_recent_date = JobDayStatistics.most_recent_date
    header = %w[job_name cumulative_runs].concat((oldest_date..most_recent_date).to_a.reverse)
    csv << header

    Job.all.sort_by(&:name).each do |job|
      puts "outputting stats for job: #{job.name}"
      data_row = [job.name, job.job_run.count]

      (oldest_date..most_recent_date).reverse_each do |day|
        js = JobDayStatistics.find_by(job_id: job.id, created_date: day)
        data_row.concat([js&.success_rate])
      end
      csv << data_row
    end
  end
  puts "pipeline reliability metrics outputted to #{filename}"
end
