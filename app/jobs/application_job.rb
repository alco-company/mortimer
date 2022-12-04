#
# Background jobs inherited from ApplicationJob and
# the 'structure' getting erected is like this
# 
# "job": {
#   "retry": true,
#   "queue": "default",
#   "class": "ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper",
#   "wrapped": "Turbo::Streams::ActionBroadcastJob",
#   "args": [
#     {
#       "job_class": "Turbo::Streams::ActionBroadcastJob",
#       "job_id": "adb7339e-61c7-4bfb-a693-c28e21364d6a",
#       "provider_job_id": null,
#       "queue_name": "default",
#       "priority": null,
#       "arguments": [ 
#         "background_jobs",
#         {
#           "action": {
#             "_aj_serialized": "ActiveJob::Serializers::SymbolSerializer",
#             "value": "prepend"
#           },
#           "target": "background_job_list",
#           "targets": null,
#           "partial": {
#             "_aj_globalid": "gid://greybox/BackgroundJob/2"
#           },
#           "locals": {
#             "background_job": {
#               "_aj_globalid": "gid://greybox/BackgroundJob/2"
#             },
#             "resource": {
#               "_aj_globalid": "gid://greybox/BackgroundJob/2"
#             },
#             "user": {
#               "_aj_globalid": "gid://greybox/User/1"
#             },
#             "_aj_symbol_keys": [
#               "background_job",
#               "resource"
#               ,"user"
#               ]
#           },
#           "_aj_ruby2_keywords": [
#             "action",
#             "target",
#             "targets",
#             "partial",
#             "locals"
#            ]
#         }
#       ],
#       "executions": 0,
#       "exception_executions": {},
#       "locale": "da",
#       "timezone": "Copenhagen",
#       "enqueued_at": "2022-11-30T19:41:40Z"
#     }
#   ],
#   "jid": "c452a423b63c0ba39dbee81e",
#   "created_at": 1669837300.247402,
#   "enqueued_at": 1669837398.703516,
#   "error_message": "undefined method `generate_key' for nil:NilClass\n\n          secret = request.key_generator.generate_key(request.encrypted_cookie_salt, key_len)\n                                        ^^^^^^^^^^^^^",
#   "error_class": "ActionView::Template::Error",
#   "failed_at": 1669837300.286945,
#   "retry_count": 2, 
#   "retried_at": 1669837337.930997
# }
#
#
class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  discard_on ActiveJob::DeserializationError

  # make sure to update the job starting this
  after_perform :update_background_job

  # make user we try to set the locale right
  around_perform :switch_locale

  #
  # allow jobs to say what they need to say
  #
  def say msg 
    Rails.logger.info "----------------------------------------------------------------------"
    Rails.logger.info msg
    Rails.logger.info "----------------------------------------------------------------------"
  end

  private

    def update_background_job
      BackgroundJob.all.where(job_id: provider_job_id).each{ |j| j.job_done }
    end
 
    def switch_locale(&action)
      locale = Current.user.profile.locale rescue set_user_locale
      locale ||= (locale || I18n.default_locale)
      I18n.with_locale(locale, &action)
    end

    def set_user_locale
      return nil unless self.respond_to? :user_id
      User.unscoped.find(self.user_id).profile.locale
    end
end
