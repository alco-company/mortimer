module SearchEngine

  def search_elements population, element
    return :or => population if !element[1].blank?

    value = element[3]
    case element[0]
    when '+'; return :and => population.collect{ |k,*v| k if v.join(" ") =~ /#{value}/i }.compact.flatten
    when '-'; return :not => population.collect{ |k,*v| k if v.join(" ") =~ /#{value}/i }.compact.flatten
    else;     return :or  => population.collect{ |k,*v| k if v.join(" ") =~ /#{value}/i }.compact.flatten
    end
  end

  # lot - could be like Avisudklip.all
  # qe - like [{:journalnr=>"<2012010"}, {:journalnr=>">2012019"}, {:"-1976"=>nil}]
  def search_where lot, qe
    order = []
    qe.compact.map do |element|
      l,k,o,q = element[0],element[1],element[2],element[3]

      next if q.nil?
      next if k.nil?
  
      case o 
      when '<','>'
        order.push "dynamic_attributes->'$.#{k}'"
        whr = "CAST(dynamic_attributes->'$.#{k}' AS DECIMAL)#{o}#{q}"  if (q.to_s == q.to_f.to_s) and q =~ /,/
        whr = "CAST(dynamic_attributes->'$.#{k}' AS UNSIGNED)#{o}#{q}"  if (q.to_s == q.to_i.to_s) and not q =~ /,/
      when '!'
        order.push "dynamic_attributes->'$.#{k}'"
        whr = "CAST(dynamic_attributes->'$.#{k}' AS UNSIGNED) <> #{q}" if (q.to_s == q.to_i.to_s)

      when '='; order.push "dynamic_attributes->'$.#{k}'"; whr = "dynamic_attributes->'$.#{k}'='#{q}'"
      when "/"; order.push "dynamic_attributes->'$.#{k}'"; whr = "dynamic_attributes->'$.#{k}' REGEXP '#{q}'"
      end

      case l
      when "-"; lot = lot.where.not whr
      else; lot = lot.where whr
      end

    end

    lot = lot.order order.uniq.join(",")
  end

  # transform "something -somefield:somethingelse"
  # into [ [logic,key,value-operator,value],.. ]
  def build_query_elements query
    qe = []
    # find key sentences: 'signatur:_"word word word .. word"' where _ is [+|-|<|>|!|=]
    # query.split(/([^ ]*:([-|+|>|<|=|!]?)".{3,}"?)|([+|-]?".{2,}?)"| /).each do |f|
    query.split(/([^ ]*".{3,}?")| /).each do |f|
      qe.push f.gsub(/\s/," *").gsub(/"/,'')
    end

    # # order remaining query elements into the array
    # query.split(' ').map do |f|
    result = []
    qe.collect do |f|
      if (m = f.match(/([+|-]?)((.{2,}?):([-|+|>|<|=|!|\/]?)(.{1,})|(.{2,}))/))
        result.push [ m[1], m[3], m[4], m[5] || m[6] ]
      end
    end
    result
  end

  # query = "forstander -side:28 +nummer:>2012000 -østerild +1827"
  def search(lot, query, format=nil, extra_fields=false)
    return lot if (query=="*") && (!self.respond_to? :dynamic_attributes)
    return search_by_model_fields lot, query unless self.respond_to? :dynamic_attributes
    qe = self.build_query_elements query

    extra_fields ||= [:id,:fulltext]
    # f = extra_fields.push qe.collect{|q| q[1].to_sym unless (q[1].nil? or q[3].nil?)}
    f = extra_fields
    lot = self.search_where lot, qe
    population = lot.pluck(*f.uniq.flatten.compact) rescue []

    areas = []
    qe.each do |q|
      areas.push search_elements(population,q)
    end
    pop = {}
    for area in areas do
      (pop[ area.keys.first ] ? pop[ area.keys.first ] = (pop[ area.keys.first ] & area.values.flatten.uniq) : pop[ area.keys.first ] = area.values.flatten.uniq) if area.keys.first == :and
      pop[ area.keys.first ] ? pop[ area.keys.first ] += area.values.flatten : pop[ area.keys.first ] = area.values.flatten if [:or, :not].include? area.keys.first
    end

    population = []
    population = pop[ :or ].uniq                if pop[ :or ] && pop[ :or ].any?
    population = pop[ :and ].uniq               if population.empty? && pop[ :and ] && pop[ :and ].any?
    population = population & pop[ :and ].uniq  if pop[ :and ] && pop[ :and ].any?
    population -= pop[ :not ].uniq              if pop[ :not ] && pop[ :not ].any?

    lot.where id: population
  end

end