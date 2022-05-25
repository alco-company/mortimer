require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Greybox
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #

    # background job executioner
    config.active_job.queue_adapter = :sidekiq

    # Since we're using Redis for Sidekiq, we might as well use Redis to back
    # our cache store. This keeps our application stateless as well.
    config.cache_store = :redis_store, ENV['CACHE_URL'],
                         { namespace: 'hours::cache' }    


    # config.time_zone = "Central Time (US & Canada)"
    #

    # we'll add a few in there, eventually
    # config.eager_load_paths << Rails.root.join("extras")
    #
    config.eager_load_paths << Rails.root.join("lib")

    #
    # previewing the components
    config.view_component.preview_paths << "#{Rails.root}/test/components/previews"

  end
end
