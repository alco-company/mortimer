module Pos
  class StockLocationsController < ApplicationController

    skip_before_action :authenticate_user!, only: [:index]

    def index
      @resource= Asset.unscoped.where( assetable: Stock.unscoped.find( params[:stock_id]) ).first
      Current.account = @resource.account
      halt unless token_approved
      say @resource.assetable.stock_locations
      @resources = @resource.assetable.stock_locations
    end

    private
    
      def token_approved
        @resource.assetable.access_token == params[:api_key]
      end


  end
end