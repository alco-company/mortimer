class AbstractResource < ApplicationRecord
  self.abstract_class = true

  #
  # default broadcasts - implement customized on model - if necessary!
  #
  after_create_commit :broadcast_create
  after_update_commit :broadcast_update
  after_destroy_commit :broadcast_destroy

  #
  # default_scope returns all posts that have not been marked for deletion yet
  # define default_scope on model if different
  #
  def self.default_scope
    Sidekiq.server? ? where(deleted_at: nil) : where(deleted_at: nil, account: Current.account)
  end
  # def self.default_scope
  #   all #Sidekiq.server? ? where(deleted_at: nil) : where(deleted_at: nil, account: Current.account)
  # end

  #
  # used for debugging
  def say(msg)
    Rails.logger.info '----------------------------------------------------------------------'
    Rails.logger.info msg
    Rails.logger.info '----------------------------------------------------------------------'
  end

  def self.say(msg)
    new.say msg
  end

  #
  # called by resource_control when creating new resources
  # for the #new action
  # resources like Event, Participant, Message, and Asset
  # will overload this method 
  def self.new_rec(_r)
    new
  end
  #
  # abstract class methods - implement on models!
  #

  #
  # implement on every model where search makes sense
  # get's called from controller specific find_resources_queried
  #
  def search_by_model_fields(_lot, _query)
    raise "you need to implement def search on the #{model_name} model - because it does not use dynamic_attributes!"
    # default_scope.where "name like '%#{query}%' "
  end

  def valid_attributes?(*attributes)
    attributes.each do |attribute|
      self.class.validators_on(attribute).each do |validator|
        validator.validate_each(self, attribute, send(attribute))
      end
    end
    errors.none?
  end

  def clone_from
    assocs = self.class.reflect_on_all_associations(:has_many).map(&:name).reject do |v|
      excluded_associations_from_cloning.push(:versions).include? v
    end
    deep_clone include: assocs
  end

  def excluded_associations_from_cloning
    raise 'You need to implement this on your model!'
  end

  #
  # used by breadcrumb - and probably other "common" tools
  #
  def name
    attributes['name']
  rescue StandardError
    raise "implement name method on the #{self.class} model"
  end


  #
  # methods supporting broadcasting
  #
  def broadcast_create
    broadcast_prepend_later_to model_name.plural, 
      target: "#{self.class.to_s.underscore}_list", 
      partial: self,
      locals: { resource: self, user: Current.user }
  end

  def broadcast_update
    if deleted_at.nil?
      broadcast_replace_later_to model_name.plural, 
        partial: self, 
        locals: { resource: self, user: Current.user }
    else
      broadcast_remove_to model_name.plural, target: self
    end
  end

  def broadcast_destroy
    after_destroy_commit { broadcast_remove_to self, 
      partial: self, 
      locals: { resource: self, user: Current.user } }
  end

  private

end
