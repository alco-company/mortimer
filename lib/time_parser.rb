module TimeParser

  # YYMMDD
  def parse_yymmdd val 
    DateTime.parse "%s/%s/%s" % [ val[0,2],val[2,2],val[4,2] ]
  end
end