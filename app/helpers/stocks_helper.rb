require "rqrcode"

module StocksHelper

  def access_token_for resource 
    host= Rails.env.development? ? "http://localhost:3000" : "https://staging.greybox.speicher.ltd"
    case resource.class.to_s
    when "Stock"; "#{host}#{pos_stock_path(resource)}?api_key=#{resource.access_token}"
    else host
    end
  end

  def svg_qr_code_link destination 
    qrcode = RQRCode::QRCode.new(destination)

    # NOTE: showing with default options specified explicitly
    svg = qrcode.as_svg(
      color: "333",
      shape_rendering: "crispEdges",
      module_size: 3,
      standalone: true,
      use_path: true
    ).html_safe    
  end
end



