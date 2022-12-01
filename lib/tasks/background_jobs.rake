desc "Prepare background jobs every midnight (this rake gets called with 'rake prepare_background_jobs' @daily from app.json)"

task prepare_background_jobs: [:environment] do 
  #
  # run the background_job#prepare 
  # midnight=true
  BackgroundJob.prepare true
end