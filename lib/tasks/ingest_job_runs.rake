# frozen_string_literal: true

desc 'ingest gitlab jobs on master branch with status of either success or failed'

task :ingest_job_runs, [:gitlab_host, :gitlab_access_token, :project_id, :page_max] do |_t, args|
  time = Benchmark.realtime do
    GITLAB_HOST = args.gitlab_host
    GITLAB_ACCESS_TOKEN = args.gitlab_access_token
    GITLAB_PROJECT_ID = args.project_id
    PAGE_MAX = args.page_max.to_i
    PATH_PIPELINES = "/api/v4/projects/#{GITLAB_PROJECT_ID}/pipelines?ref=master"

    jobs_options = { query: { per_page: 100 },
                     headers: { 'private-token' => GITLAB_ACCESS_TOKEN } }

    (1..PAGE_MAX).each do |page|
      puts "ingesting pipelines page #{page}"
      pipelines_options = { query: { page: page, per_page: 10 },
                            headers: { 'private-token' => GITLAB_ACCESS_TOKEN } }
      pipelines_response = HTTParty.get("https://#{GITLAB_HOST}#{PATH_PIPELINES}", pipelines_options)

      pipelines = JSON.parse(pipelines_response.body, { symbolize_names: true })

      pipelines.each do |pipeline|
        id = pipeline[:id]
        p = Pipeline.find_or_create_by!(resource_id: id)
        puts "ingesting jobs from pipeline #{id}"

        path_jobs = "/api/v4/projects/#{GITLAB_PROJECT_ID}/pipelines/#{id}/jobs?scope[]=#{JobRun::FAILED}&scope[]=#{JobRun::SUCCESS}"

        jobs_response = HTTParty.get("https://#{GITLAB_HOST}#{path_jobs}", jobs_options)

        job_runs = JSON.parse(jobs_response.body, { symbolize_names: true })

        job_runs.each do |job_run|
          job = Job.find_or_create_by!(name: job_run[:name])

          JobRun.find_or_create_by!(resource_id: job_run[:id],
                                    status: job_run[:status],
                                    stage: job_run[:stage],
                                    ref: job_run[:ref],
                                    created_at: job_run[:created_at],
                                    started_at: job_run[:started_at],
                                    finished_at: job_run[:finished_at],
                                    duration: job_run[:duration],
                                    job_id: job.id,
                                    pipeline_id: p.id)
        end
      end
    end
  end
  puts "jobs ingested successfully in #{time} secs"
end
