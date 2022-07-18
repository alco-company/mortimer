module TimeParser

  # YYMMDD
  def parse_yymmdd val 
    begin
      DateTime.parse "%s/%s/%s" % [ val[0,2],val[2,2],val[4,2] ]
    rescue => exception
      false
    end
  end
end