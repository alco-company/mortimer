class SpeicherController < AbstractResourcesController

  #
  # make it easy to do pagination of resources
  #
  include Pagy::Backend
end