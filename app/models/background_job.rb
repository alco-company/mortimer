#
# t.references :account, null: false, foreign_key: true
# t.references :user, null: false, foreign_key: true
# t.string :klass
# t.text :params
# t.text :schedule
# t.datetime :next_run_at
# t.string :job_id
#
class BackgroundJob < AbstractResource
  #
  # prepareable makes it possible to
  # run cron_task and rrule on background_jobs
  # in order to prepare them for processing
  # as ActiveJobs (backed by Sidekiq)
  #
  include Prepareable
  
  validates :klass, presence: true
  validates :klass, background_job: true 
  belongs_to :account
  belongs_to :user, optional: true

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
    default_scope.where "klass like '%#{query}%' "
  end

  def broadcast_update 
    user = Current.user || set_user
    if self.deleted_at.nil? 
      broadcast_replace_later_to model_name.plural, 
        partial: self, 
        locals: { resource: self, user: user }
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

  private 
    def set_user 
      User.unscoped.find self.user_id 
    end
end
