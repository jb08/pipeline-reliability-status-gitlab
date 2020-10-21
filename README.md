# README

Gives you data to help find and fix your persistently flaky pipeline jobs!! Calculates historical CI/CD master-branch pipeline reliability using the Gitlab Api.

## How to run

Retrieve your gitlab host, ie. gitlab.example.com.

Retrieve your project (repo) id, ie. 124.

Retrieve your personal gitlab access token with api-rights. Instructions [here](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html).

Determine how many 100-page pipelines you want, ie. 10 (1000 most-recent master-branch pipelines).

```
$ bundle install
$ bundle exec rails db:create db:migrate
$ bin/rake "ingest_job_runs[YOUR-GITLAB-HOST, YOUR-GITLAB-ACCESS-TOKEN-HERE, YOUR_PROJECT_ID, PAGE_MAX]"
$ bin/rake "output_metrics_csv[]"
> Pipeline reliability metrics outputed to job_reliability_stats_output.csv
```

### Sample logs

```
ingesting pipelines page 1
ingesting jobs from pipeline 125
ingesting jobs from pipeline 126
ingesting jobs from pipeline 127
ingesting jobs from pipeline 128
ingesting jobs from pipeline 129
ingesting jobs from pipeline 130
ingesting jobs from pipeline 131
...
ingesting pipelines page 2
ingesting jobs from pipeline 132
ingesting jobs from pipeline 133
...
jobs ingested successfully in 58 secs

Pipeline reliability metrics outputed to job_reliability_stats_output.csv
```
