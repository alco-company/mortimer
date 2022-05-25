Rails.application.config.cache_store = :redis_store, ENV['CACHE_URL'],
                         { namespace: 'hours::cache' }
Rails.application.config.active_job.queue_adapter = :sidekiq
Sidekiq.configure_server do |config|
  config.redis = {url: ENV['WORKER_URL']}
  #   config.redis = { url: ENV.fetch('REDIS_URL_SIDEKIQ', 'redis://localhost:6379/1') }
end
