class PupilTransaction < AbstractResource
  include Eventable
  
  belongs_to :asset
  belongs_to :pupil

  def self.default_scope
    PupilTransaction.all.joins(:event)
  end


  #
  # methods supporting broadcasting
  #
  def broadcast_create
    broadcast_prepend_later_to model_name.plural, 
      target: "pupil_transaction_list", 
      partial: "pupil_transactions/pupil_transaction",
      locals: { resource: self, user: Current.user }
  end

  def broadcast_update
    if deleted_at.nil?
      broadcast_replace_later_to model_name.plural, 
        target: "pupil_transaction_list", 
        partial: "pupil_transactions/pupil_transaction",
        locals: { resource: self, user: Current.user }
    else
      broadcast_remove_to model_name.plural, target: self
    end
  end

  def broadcast_destroy
    # after_destroy_commit { broadcast_remove_to self, 
    #   partial: self, 
    #   locals: { resource: self, user: Current.user } }
  end

end
