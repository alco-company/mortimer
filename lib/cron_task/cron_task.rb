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

    def self.stamp2string ts 
      DateTime.strptime(ts.to_s,'%s')
    end

    #
    # is this crontask now?
    # allow a minute on both sides!
    #
    def self.now? crontask=nil, dt=nil
      return false unless dt = self.args_valid?(crontask, dt)
      return false unless mapping = self.get_date_runs(crontask, dt)
      return false unless mapping[1].include?(dt.hour)
      ((dt - 1.minute).minute .. (dt + 1.minute).minute).each{ |m| return true if mapping[0].include? m }
      false
    rescue
      false
    end

    #
    # when is this crontask due next time? 
    # consider today, return first timestamp
    # scope allows for returning next_run even if in 10 years
    #
    def self.next_run crontask, dt=nil, number=0, scope='today', only_later=true
      return nil unless dt = self.args_valid?(crontask, dt)
      dt = dt + 1.minute
      self.sorted_datetime_today(crontask,dt,only_later,scope)[ number ] 
    # rescue 
    #   nil      
    end

    #
    # any due times today for this crontask?
    #
    def self.runs_today crontask=nil, dt=nil 
      return [] unless dt = self.args_valid?(crontask, dt)
      self.sorted_datetime_today crontask, dt rescue []
    end
    
    private

      #
      # do we provide the correct arguments?
      # crontask: * * * * * /some/task
      # dt: nil or DateTime something - but never in the past!
      # 'cause cron only deals in the future of events
      #
      def self.args_valid? crontask=nil, dt=nil 
        the_past = DateTime.current
        return false if crontask.strip.blank?
        dt ||= DateTime.current 
        return false if dt < the_past
        dt
      end

      #
      # return the mapping of some day 
      # [[minutes],[hrs],[days],[months],[week days]]
      #
      def self.get_date_runs crontask, dt=nil
        mapping = MappingGenerator.new(crontask).call
        return false unless ( mapping[4].include?(dt.wday) && mapping[3].include?(dt.month) && mapping[2].include?(dt.day) )
        mapping
      rescue
        false
      end

      #
      # scope 'hour','today','month','year','any' - meaning 
      # if scope is today only mappings today are considered, etc
      #
      # return sort min to max timestamps for the mapping 
      # pertaining to some DateTime
      # [ts,ts,ts,ts]
      #
      def self.sorted_datetime_today crontask, dt, only_later=false, scope='today'
        return [] unless mapping = self.get_date_runs(crontask, dt)
        mapping = self.anything_later(mapping,dt,scope) if only_later
        now = only_later ? dt : DateTime.current.at_beginning_of_day
        r = []
        case scope 
        when 'hour'
          template = "%s-%s-%s %s:" % [dt.year,dt.month,dt.day, dt.hour]
          template += "%s:00"
          mapping[0].each do |min|
            t= DateTime.parse(template % [min])
            r.push t.to_f unless t < now
          end
        when 'today'
          template = "%s-%s-%s" % [dt.year,dt.month,dt.day]
          template += " %s:%s:00"
          mapping[1].each do |hr|
            mapping[0].each do |min|
              t= DateTime.parse(template % [hr,min])
              r.push t.to_f unless (t < now and only_later)
            end
          end
        when 'month'
          template = "%s-%s-" % [dt.year,dt.month]
          template += "%s %s:%s:00"
          mapping[2].each do |d|
            mapping[1].each do |hr|
              mapping[0].each do |min|
                t= DateTime.parse(template % [d,hr,min])
                r.push t.to_f unless (t < now and only_later)
              end
            end
          end
        when 'year','any'
          template = "%s-" % [dt.year]
          template += "%s-%s %s:%s:00"
          mapping[3].each do |m|
            mapping[2].each do |d|
              mapping[1].each do |hr|
                mapping[0].each do |min|
                  t= DateTime.parse(template % [m,d,hr,min]) rescue nil
                  r.push t.to_f unless (t.nil? or (t < now and only_later))
                end
              end
            end
          end
        end
        r.sort
      # rescue
      #   []
      end

      #
      # get only the hrs/min after now
      # scope 'today','month','year','any' - meaning 
      # if scope is today only mappings today are considered, etc
      # 
      def self.anything_later mapping, dt, scope
        case scope
        when 'hour'
          return [[],[],[],[],[]] unless mapping[1].include? dt.hour
          mapping[0] = mapping[0].filter{|m| m if (m >= dt.minute) }
        when 'today'
          mapping[3] = mapping[3].filter{|m| m if m == dt.month }  
          mapping[2] = mapping[2].filter{|m| m if m == dt.day }  
          mapping[1] = mapping[1].filter{|h| h unless h < dt.hour }
        when 'month'
          mapping[3] = mapping[3].filter{|m| m if m == dt.month }  
          mapping[2] = mapping[2].filter{|m| m unless m < dt.day }  
        when 'year'
          mapping[3] = mapping[3].filter{|m| m unless m < dt.month } 
        when 'any'
          # mapping
        else return [[],[],[],[],[]]
        end
        mapping
      end

      def self.cron_job_regexp
        /([^\s]+)\s([^\s]+)\s([^\s]+)\s([^\s]+)\s([^\s]+)\s([^#\n$]*)(\s#\s([^\n$]*)|$)/
      end


    def self.error_message
<<-HEREDOC
Invalid cron task
Please provide a valid cron task in a string
Usage:
bin/cronparse "* * * * * bin/do_something"
HEREDOC
    end

  end
end