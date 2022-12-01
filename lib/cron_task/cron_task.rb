require 'cron_task/mapping_generator'
require 'cron_task/presenter'
require 'cron_task/time_lapse_interpreter'

module CronTask
  class CronTask
    def self.explain(crontask)
      if crontask =~ cron_job_regexp
        mapping = MappingGenerator.new(crontask).call
        puts Presenter.new(mapping)
      else
        print error_message
      end
    end

    def self.now? crontask=nil, dt=nil
      return false if crontask.strip.blank?
      dt ||= DateTime.current 
      return false if dt < (DateTime.current - 1.minute)
      mapping = MappingGenerator.new(crontask).call
      return false unless (mapping[1].include?(dt.hour) && mapping[2].include?(dt.day) && mapping[3].include?(dt.month) && mapping[4].include?(dt.wday))
      ((dt - 1.minute).minute .. (dt + 1.minute).minute).each{ |m| return true if mapping[0].include? m }
      false
    rescue
      false
    end

    def self.runs_today crontask=nil 
      return [] if crontask.blank?
      dt = DateTime.current 
      mapping = MappingGenerator.new(crontask).call
      return [] unless (mapping[2].include?(dt.day) && mapping[3].include?(dt.month) && mapping[4].include?(dt.wday))
      r = []
      template = "%s-%s-%s" % [dt.year,dt.month,dt.day]
      template += " %s:%s:00"
      mapping[1].each do |hr|
        mapping[0].each do |min|
          r.push DateTime.parse(template % [hr,min]).to_f
        end
      end
      r
    end
    
    private

    def self.error_message
<<-HEREDOC
Invalid cron task
Please provide a valid cron task in a string
Usage:
bin/cronparse "* * * * * bin/do_something"
HEREDOC
    end

    def self.cron_job_regexp
      /([^\s]+)\s([^\s]+)\s([^\s]+)\s([^\s]+)\s([^\s]+)\s([^#\n$]*)(\s#\s([^\n$]*)|$)/
    end
  end
end