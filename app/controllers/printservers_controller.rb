class PrintserversController < AssetsController

  layout :find_layout
  skip_before_action :authenticate_user!, only: [:ip,:port]

  def set_resource_class 
    @resource_class= Printserver
  end

  def new 
    resource.assetable.port = Printserver.all.order(:port).last.port.to_i + 1 rescue 2000
    super
  end

  def ip
    ps, asset = find_printserver
    asset.update_attribute :updated_at, DateTime.now if asset
  end

  def port
    ps, asset = find_printserver
    asset.update_attribute :updated_at, DateTime.now if asset
    @resource=ps
  end

  private

    def find_layout
      return false if request.path =~ /port|ip$/
      super
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      params.require(:asset).permit(:assetable_type, :name, :state, :account_id, 
        assetable_attributes: [ :id, :mac_addr, :port ] )
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      Printserver.search Printserver.all, params[:q]
    end

    def find_printserver
      ps = Printserver.unscoped.find_by( mac_addr: params[:mac]) rescue nil
      return [ps, Asset.unscoped.find_by( assetable_type: "Printserver", assetable_id: ps.id)] if ps
      nil
    end

  end
