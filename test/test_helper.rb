ENV["RAILS_ENV"] ||= "test"
ENV["REDIS_URL"] ||= "redis://0.0.0.0:6379/0"

require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # Add more helper methods to be used by all tests here...
  def say msg 
    puts "----------------------------------------------------------------------"
    puts msg
    puts "----------------------------------------------------------------------"
  end

end
