require 'test_helper'

class FakeController <  ActionController::Base
  include ParentControl # this is my controller's concern to test

  setup do
    @emp = employees(:one)
  end

  def index
    @parent = find_parent "/employees/#{@emp.id}/pupils/2"
    # The concern modify some of the parameters, so I'm saving them in a
    # variable for future test inspection, so YMMV here.
    head 200
  end
end

Rails.application.routes.disable_clear_and_finalize = true
Rails.application.routes.draw do
  # Adding a route to the fake controller manually
  get 'index' => 'fake#index'
end

class FakeControllerTest < ActionController::TestCase
  def test_index
    parent = get(:index)
    # finally checking if the parameters were modified as I expect
  end
end