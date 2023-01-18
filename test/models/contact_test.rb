require "test_helper"

class ContactTest < ActiveSupport::TestCase

  def setup 
    Current.account = accounts(:one)
  end

  test "should not save contact without name" do  
    #contacts(:one)
  end
end
