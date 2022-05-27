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
    return @authorized = true if (current_user && current_user.can( :all, :general)) # a real superuser - apparently they do exist!!
    @authorized = current_user.can action, endpoint
    flash.now[:warning] = raw_t(:not_authorized) unless @authorized
    @authorized
  rescue
    say "(authorize) User #{Current.user.id} failed checking if #{action} against #{endpoint} is authorized"
    @authorized = false
  end

  def not_authorized 
    # render turbo_stream: [
    #   turbo_stream.replace( "unauthorized", partial: 'shared/unauthorized'), 
    #   turbo_stream.remove( "resource_form") 
    # ]
    render turbo_stream: turbo_stream.replace( "unauthorized", partial: 'shared/unauthorized' ), status: :unauthorized
  end

  private

end