class ProductsController  < AssetsController

  def set_resource_class
    @resource_class= Product
  end

  # def new_resource 
  #   resource_class= Product
  #   super
  # end

  private 

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      supplier = params[:asset][:assetable_attributes][:supplier_id]
      params[:asset][:assetable_attributes][:supplier_id] = supplier.is_a?(Array) ? supplier.compact_blank!.join : supplier
      params.require(:asset).permit(:assetable_type, :name, :account_id, assetable_attributes: [ :id, :supplier_id, :supplier_barcode ] )
    end

    #
    # implement on every controller where search makes sense
    # geet's called from resource_control.rb 
    #
    def find_resources_queried options
      Product.search Product.all, params[:q]
    end

  end
