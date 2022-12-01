require 'sidekiq/api'

module Prepareable
    extend ActiveSupport::Concern

    included do
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
      def prepare midnight=false

        # do some housecleaning first
        self.clean_sidekiq if midnight

        # push jobs set to run already
        all.where("next_run_at is not null and next_run_at <= ?", DateTime.current).find_each do |job|
          self.run_job job
        end

        # push jobs not yet set to run
        all.where(next_run_at: nil).find_each do |job|
          if job.schedule.blank?
            i,t = self.run_job(job)
          else 
            i,t = self.plan_run(job)
          end
          job.update job_id: i, next_run_at: t
        end

        # set this job to run in 5 minutes
        dt = DateTime.current + 5.minutes
        BackgroundProcessingJob.set( wait_until: dt).perform_later({})
      end

      def clean_sidekiq
        ss = Sidekiq::ScheduledSet.new
        ss.scan("BackgroundProcessingJob").map(&:delete)

        ds = Sidekiq::DeadSet.new
        ds.clear 

        rs = Sidekiq::RetrySet.new
        rs.clear    
      end

      # if job.schedule
      # then get the next planned run, set the job to run at that time
      # and get the next_run after that and set the job to run at that time
      def plan_run job 
        dt = self.next_run job.schedule
        return [nil,nil] unless dt 
        i, _t = self.run_job job, dt

        [ i, self.next_run( job.schedule, false) ]
      end

      #
      # set a job to run now
      # or later at t 
      def run_job job, t=nil
        o = self.set_parms job
        w = job.klass.constantize
        i = t ? w.set( wait_until: t).perform_later(o).job_id : w.perform_later(o).job_id
        [i,t]
      end

      # 
      # set the job params if any
      #
      # define params - "id:1,filter:'max',...,more"
      def set_parms job 
        o = {}
        unless job.params.blank?
          job.params.split(",").each{ |v| (vs=v.split(":"); o[ vs[0].strip ] = vs[1].strip ) }
        end
        o
      end

      #
      # if rrule contains /^RRULE*/ dechiffre the rrule
      # otherwise consider it a cron schedule - https://en.wikipedia.org/wiki/Cron#Overview 
      #
      # 
      def next_run schedule, first=true 
        schedule =~ /^RRULE/ ? self.rrule_runs(schedule,first) : self.cron_runs(schedule,first)
      end

      #
      # TODO allow execute_at to hold rrule's instructing SPEICHER as to the when
      def rrule_runs rrule, first
        nil
      end

      #
      # parse a cron schedule
      # return an array of timestamp for scheduling today
      # but don't send more than the first - after DateTime.current - back
      def cron_runs schedule,first 
        arr = CronTask::CronTask.runs_today( schedule )
        if arr.any?
          return arr[0] if first
          return arr[1] if arr.size > 1
        end
        nil
      end

    end
end