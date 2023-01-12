class RoutingConstraint
  class << self
    def matches?(request)
      usr = find_user(request)
      usr && usr.can( :read, :sidekiq)
    rescue
      false
    end

    private
      def find_user request
        if request.session[:current_user_session_token].present?
          return User.unscoped.find_by(session_token: request.session[:current_user_session_token])
        elsif request.cookies.permanent.encrypted[:remember_token].present?
          return User.unscoped.find_by(remember_token: request.cookies.permanent.encrypted[:remember_token])
        end
        nil
      end
  end
end