module Pos
  class PupilTransactionsController < EventsController

    skip_before_action :current_user, only: [:create]
    skip_before_action :breadcrumbs
    skip_before_action :current_account, only: [:create]
    skip_before_action :authenticate_user!, only: [:create]

    def set_resource_class
      @resource_class= PupilTransaction
    end


    def new_resource 
      Event.new eventable: resource_class.new
    end

    def create
      head 301 and return unless token_approved
      PupilTransactionService.new.create_pupil_transaction( resource_params, parent ) if params['pupil_transaction']
      head 200
    end

    private 

      # Never trust parameters from the scary internet, only allow the white list through.
      def resource_params
        params.require(:pupil_transaction).permit(:pupil_id, :state, :location, :employee_asset_id, :punched_at)
      end

      #
      # implement on every controller where search makes sense
      # geet's called from resource_control.rb 
      #
      def find_resources_queried options
        PupilTransaction.search PupilTransaction.all, params[:q]
      end

      def token_approved
        Current.account = parent.account
        Current.user ||= Current.account.users.first
        parent.access_token == params[:api_key]
      end

  end
end