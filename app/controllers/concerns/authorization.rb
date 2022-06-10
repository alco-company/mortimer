module Authorization
  extend ActiveSupport::Concern

  #
  # TODO: implement alternative to Pundit - or implement Pundit!
  # no pundit!
  #
  # authorize
  #
  def authorize action, endpoint=nil
    endpoint ||= resource_class.to_s.underscore

    @authorized = true
    return @authorized if (Current.account != Current.user.account)

    return @authorized = true if (Rails.env == 'test')
    return @authorized = true if (current_user && current_user.is_a_god?) # a real superuser - apparently they do exist!!
    return @authorized = false if endpoint=='account'

    @authorized = current_user.can action, endpoint
    flash.now[:warning] = raw_t(:not_authorized) unless @authorized
    @authorized
  rescue
    say "(authorize) User #{Current.user.id} failed checking if #{action} against #{endpoint} is authorized"
    @authorized = false
  end

  def not_authorized redirect=false
    # render turbo_stream: [
    #   turbo_stream.replace( "unauthorized", partial: 'shared/unauthorized'), 
    #   turbo_stream.remove( "resource_form") 
    # ]
    flash[:warning] = flash.now[:warning]; redirect_to root_path and return if redirect
    render turbo_stream: turbo_stream.replace( "unauthorized", partial: 'shared/unauthorized' ), status: :unauthorized
  end

  private

end