module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_pos
 
    def connect
      self.current_pos = find_verified_pos if request.params[:token]
    end
 
    private
      def find_verified_pos
        token = Employee.where(access_token: request.params[:token]).first
        if verify_token(token)
          current_pos = token
        else
          reject_unauthorized_connection
        end
      end

      def verify_token(token)
        !token.nil? # && !token.expired? && !token.revoked?
      end
    
  end
end
