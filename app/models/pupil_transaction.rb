class PupilTransaction < AbstractResource
  include Eventable
  
  belongs_to :asset
  belongs_to :pupil

  def self.default_scope
    PupilTransaction.all.joins(:event)
  end

end
