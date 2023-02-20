#
# :event - what event does this assignment belong to
# :assignable - who is the assignee (participant,asset,message)
# :assignable_role - what role does the assignee hold (owner,pm,qa,member/worker,etc)
# :deleted_at - 
#
class Assignment < AbstractResource

  belongs_to :event, inverse_of: :assignments
  belongs_to :assignable, polymorphic: true, required: true

  accepts_nested_attributes_for :assignable

  def self.default_scope
    where(deleted_at: nil)
  end

  #
  # used by clone_from method on abstract_resource
  # to exclude has_many associations which should not be cloned
  # when making a copy of some instance of a model
  #
  def excluded_associations_from_cloning
    []
  end

  
  # 
  # methods supporting broadcasting 
  #
  def broadcast_create
    self.assignable.broadcast_create if self.assignable
  end
  
  def broadcast_update 
    self.assignable.broadcast_update if self.assignable
  end
  
  def broadcast_destroy
    self.assignable.broadcast_destroy if self.assignable
  end
  #
  #
  
  private
  
end