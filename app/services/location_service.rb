class LocationService < AssetService

  def get_by field, parm 
    (Location.unscoped.find_by(field => parm["long_lat"]).asset rescue nil) || create_location( parm)
  end

  def new_location account=nil
    account ||= Current.account
    loc = Location.new
    Asset.new account: account, assetable: loc
  end

  def create_location parm 
    loc = Location.new( long_lat: parm["long_lat"] )
    resource = Asset.new name: parm["name"], assetable: loc
    result = create(resource, Location)
    return result.record if result.created?
    nil
  end

end