# app/controllers/concerns/breadcrumbs.rb
module Breadcrumbs
  extend ActiveSupport::Concern

  included do
    before_action :breadcrumbs
  end
  
  # /accounts/1/stocks/87/stock_locations/3/edit
  # [["/accounts", "/1"], ["/stocks", "/87"], ["/stock_locations", "/3"], ["/edit", nil]]
  #
  def breadcrumbs
    routes = request.path.scan /(\/[^\/]*)(\/\d+){0,1}/i
    @breadcrumbs = [{label: I18n.t('breadcrumbs.home'), url: root_url}]
    if request.path.match /.*?\.\d/
      Rails.logger.warn "Request query error: #{request.path}"
      return @breadcrumbs
    end
    return @breadcrumbs if request.path =~ /profile/
    # ""
    # "/accounts"
    # "/accounts/1"
    # "/accounts/1/stocks"
    # "/accounts/1/stocks/87"
    # "/accounts/1/stocks/87/stocked_products"
    # "/accounts/1/stocks/87/stock_locations/new_stock"
    entire_path = []
    step=0
    # Rails.logger.warn ">>>> #{routes.to_json}"
    routes.each do |r|
      next if r[0] == "/pos"
      step += 1
      break if routes.count==1 && r[0]=="/"
      break if (%w{ /new /edit }.include? r[0])
      resources = r[0].gsub('/','')
      @breadcrumbs.push label: I18n.t("breadcrumbs.#{resources}"), url: "#{entire_path.join}#{r[0]}"
      break if r[0]=="/accounts" && request.path =~ /impersonate/
      if r.compact.count > 1 or routes.size > step
        entire_path.push r.join
        # break if entire_path.join == request.path
        next if r[1].nil?
        id = r[1].gsub "/", ""
        resource = resources.singularize.classify.constantize
        @breadcrumbs.push label: resource.find( id ).name, url: entire_path.join
      end
    end
    @breadcrumbs
  end


end
