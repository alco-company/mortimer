require 'sidekiq/api'

module Prepareable
  extend ActiveSupport::Concern

  included do

    #
    # when the background_job has performed
    # it will callback and make sure the job_id 
    # is reset
    def job_done
      if schedule.blank?
        t = nil
      else
        next_run_at > DateTime.current + 1.minute ? first = false : first = true
        t = BackgroundJob.next_run self.schedule, first
        t = Time.at t.to_i, in: "UTC"
      end
      update next_run_at: t, job_id: nil
    end

    #
    # when resetting for a new 'day' remove the 
    # next_run_at
    def job_reset
      update next_run_at: nil, job_id: nil
    end

    # if job.schedule
    # then get the next planned run, set the job to run at that time
    # and return the job id and planned run at time
    #
    def plan_run  
      t = BackgroundJob.next_run schedule
      return [nil,nil] unless t

      id,t = run_job t
      t = Time.at t.to_i, in: "UTC"
      [id,t]
    end

    #
    # set a job to run now
    # or later at t 
    def run_job t=nil
      o = set_parms
      w = klass.constantize
      id = t ?( w.set( wait_until: t).perform_later(o)).provider_job_id : (w.perform_later(o)).provider_job_id
      [id,t]
    end

    # 
    # set the job params if any
    #
    # define params - "id:1,filter:'max',...,more"
    def set_parms 
      o = {}
      unless params.blank?
        params.split(",").each{ |v| (vs=v.split(":"); o[ vs[0].strip ] = vs[1].strip ) }
      end
      o
    end


  end

  class_methods do

    #
    # from the rake task prepare_background_jobs 
    # this method gets called by cron (via app.json) @daily
    #
    # then it keeps itself running - presumably - all day
    # first, when called at midnight, we do some house cleaning
    # then, we push jobs that are set to run already
    # then, we push jobs with no next_run_at
    # finally, we make sure this job will start in 5 minutes
    #
    # regarding timezones - this is UTC land - and that's what
    # any dates arriving should be considered to be!
    def prepare midnight=false

      # do some housecleaning first
      self.reset_all_jobs if midnight

      # reset jobs that failed - 
      # which should show if next_run_at is set and job_id too or 
      # vice versa
      all
        .where("job_id is not null and next_run_at is not null and next_run_at <= ?", (DateTime.current - 4.minutes))
        .map &:job_reset

      # push jobs set to run already
      all
        .where("active=true and job_id is null and next_run_at is not null and next_run_at <= ?", DateTime.current)
        .find_each do |job|
          id,t = job.run_job
          job.update job_id: id
        end

      # push jobs not yet set to run
      all
        .where(job_id: nil, active: true)
        .find_each do |job|
          if job.schedule.blank?
            id,t = job.run_job
          else
            id,t = job.plan_run
          end
          job.update job_id: id, next_run_at: t
        end

      # finally, set this job to run in 5 minutes
      dt = DateTime.current + 5.minutes
      BackgroundProcessingJob.set( wait_until: dt).perform_later({})
    end

    #
    # reset all jobs - get ready for a new 'day'
    #
    def reset_all_jobs
      all.map &:job_reset
      self.clean_sidekiq
    end

    #
    # clean the sidekiq scheduledset, deadset, and retryset
    # of jobs waiting to be queued
    def clean_sidekiq
      ss = Sidekiq::ScheduledSet.new
      ss.map(&:delete)
      # ss.scan("BackgroundProcessingJob").map(&:delete)

      ds = Sidekiq::DeadSet.new
      ds.clear 

      rs = Sidekiq::RetrySet.new
      rs.clear    
    end

    #
    # if rrule contains /^RRULE*/ dechiffre the rrule
    # otherwise consider it a cron schedule - https://en.wikipedia.org/wiki/Cron#Overview 
    #
    # 
    def next_run schedule, first=true 
      return nil if schedule.blank?
      schedule =~ /^RRULE/ ? self.rrule_runs(schedule,first) : self.cron_runs(schedule,first)
    end

    #
    # TODO allow execute_at to hold rrule's instructing SPEICHER as to the when
    def rrule_runs rrule, first
      nil
    end

    #
    # parse a cron schedule
    # crontask, dt=nil, number=0, scope='today', only_later=true
    # return the first - after DateTime.current - back
    #
    def cron_runs schedule,first 
      # crontask, dt=nil, number=0, scope='today', only_later=true
      CronTask::CronTask.next_run( schedule, nil, (first ? 0 : 1)  )
    end

  end
end