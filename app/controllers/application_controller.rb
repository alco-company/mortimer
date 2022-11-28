class ApplicationController < ActionController::Base

  before_action :set_cache_buster

  #
  # TODO activate when ready for production!
  # rescue_from Exception, with: :handle_all_errors

  # 
  # This is essential to all controllers which is
  # why it gets included on the ApplicationController
  # and not the AbstractResourcesController - by inheriting
  # from the ApplicationController you may skip some of the
  # automagic - but authentication cannot be skipped; you can
  # override this, however, on controllers by calling 
  # skip_before_action :authenticate_user!
  #
  # TODO - enable before production - before_action :authenticate_user! #, except: :index
  include Authentication

  #
  # this include will assign the client platform
  # and case on iPad, iPhone|Android, and more
  # and set the request.variant accordingly
  #
  # assign the client platform and thus allow
  # us to cater for platforms like iPhone, iPad, Android, Windows, Linux
  #
  include ClientControl

  #
  # handling locale
  #
  around_action :switch_locale

  #
  # about handling date and timezone
  # https://nandovieira.com/working-with-dates-on-ruby-on-rails
  #
  around_action :user_time_zone, if: :current_user 

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
      locale = extract_locale_from_tld || I18n.default_locale
      locale = params[:locale] || locale
      # locale = current_user.preferred_locale if current_user rescue locale
      parsed_locale = (current_user.locale.blank? ? locale : current_user.locale.to_sym) rescue locale
      I18n.with_locale(parsed_locale, &action)
    end

    # Get locale from top-level domain or return +nil+ if such locale is not available
    # You have to put something like:
    #   127.0.0.1 application.com
    #   127.0.0.1 application.it
    #   127.0.0.1 application.pl
    # in your /etc/hosts file to try this out locally
    def extract_locale_from_tld
      parsed_locale = request.host.split('.').last
      I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
    end

    #
    # make sure we use the timezone (of the current_user)
    # TODO - add time_zone to profiles_controller - and a loookup - and a field on the user
    #
    def user_time_zone(&block)
      current_user.time_zone.blank? ? 
        Time.use_zone('UTC',&block) :
        Time.use_zone(current_user.time_zone, &block) 
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
