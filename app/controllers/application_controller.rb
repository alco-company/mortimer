class ApplicationController < ActionController::Base

  before_action :set_cache_buster

  #
  # handling locale
  #
  around_action :switch_locale

  #
  # about handling date and timezone
  # https://nandovieira.com/working-with-dates-on-ruby-on-rails
  #
  # around_action :user_time_zone

  private


    # allow HTML in i18n
    def raw_t msg 
      t(msg).html_safe
    end
      
    def set_cache_buster
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end  

    #
    # switch locale to user preferred language - or by params[:locale]
    #
    def switch_locale(&action)
      locale = params[:locale] || I18n.default_locale
      locale = current_user.preferred_locale if current_user rescue locale
      I18n.with_locale(locale, &action)
    end

    #
    # make sure we use the timezone (of the current_user)
    #
    def user_time_zone(&block)
      (current_user && current_user.time_zone) ? Time.use_zone(current_user.time_zone, &block) : Time.use_zone('Europe/Copenhagen',&block)
    end

    # def handle_all_errors(e)
    #   flash[:error] = e.message
    #   say e.message
    #   redirect_to (request.referrer || root_url)
    # end

    def say msg 
      return unless Rails.env.development?
      Rails.logger.info '--------------------------------------------------------'
      Rails.logger.info msg
      Rails.logger.info '--------------------------------------------------------'
    end
  
end
