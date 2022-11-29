class BackgroundJob < AbstractResource
  
  validates :work, presence: true

  has_and_belongs_to_many :accounts

  #
  # default_scope returns all posts that have not been marked for deletion yet
  # define default_scope on model if different
  #
  def self.default_scope
    where(deleted_at: nil)
  end


  #
  # implement on every model where search makes sense
  # get's called from controller specific find_resources_queried
  #
  def self.search_by_model_fields lot, query
    default_scope.where "work like '%#{query}%' "
  end

  #
  # from the rake task prepare_background_jobs 
  # this method gets called by cron (via app.json) @daily
  def self.prepare
    all.each do |job|
      #
      # define params - "id:1,filter:'max',...,more"
      o = {}
      unless job.params.blank?
        job.params.split(",").each{ |v| (vs=v.split(":"); o[ vs[0].strip ] = vs[1].strip ) }
      end
      #
      # define the ActiveJob
      w = eval(job.work)
      i = []
      if job.execute_at.blank?
        i.push w.perform_later(o)
      else
        self.all_runs_today(job.execute_at).each do |r|
          i.push w.set( wait_until: r).perform_later(o).job_id
        end
      end
      job.update job_id: i.join(",")
    end
  end

  #
  # TODO allow execute_at to hold rrule's instructing SPEICHER as to the when
  def self.all_runs_today rrule 
    [DateTime.parse( rrule )]
  end


  def broadcast_update 
    if self.deleted_at.nil? 
      broadcast_replace_later_to model_name.plural, 
        partial: self, 
        locals: { resource: self, user: Current.user }
    else 
      broadcast_remove_to model_name.plural, target: self
    end
  end

  #
  # used by clone_from method on abstract_resource
  # to exclude has_many associations which should not be cloned
  # when making a copy of some instance of a model
  #
  def excluded_associations_from_cloning
    []
  end

end
