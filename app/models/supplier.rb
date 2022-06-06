class Supplier < AbstractResource
  include Participantable

  has_many :products, dependent: :destroy 
  
  validates :gtin_prefix, presence: true

  #
  # default_scope returns all posts that have not been marked for deletion yet
  #
  def self.default_scope
  #   where("assetable" deleted_at: nil)
    Supplier.all.joins(:participant)
  end

  def self.create_for_product account, parm 
    say account.to_json
    s = Supplier.find_by_prefix parm["ean14"]
    unless s 
      #
      # search the https://gepir.gs1.org/index.php/search-by-gtin somwhow to find the correct supplier
      #
      sup = Supplier.create!( gtin_prefix: parm["ean14"][4,4])
      cal = Calendar.create!( name: parm["ean14"] )
      participant = Participant.create! name: parm["ean14"], 
        account: account,
        calendar: cal,
        participantable: sup

      s= Supplier.find participant.participantable_id
    end
    s
  end

  def self.find_by_prefix barcode 
    #
    # this really should go through all 
    # combinations starting with 3 digits all the way to 6 digits
    #
    #            05711426101029
    #            abbbccccddddde
    #
    #            a = EAN14 (outer box product identifier)
    #            b = EAN13 country prefix
    #            c = EAN13 product manufacturer prefix
    #            d = EAN14 product identifier
    #            e = check digit
    #
    barcode = "0" + barcode if barcode.length == 13
    id = Supplier.all.pluck(:id, :gtin_prefix).select{ |k,v| barcode[4,7].match(Regexp.new(v)) ? k : nil  }.compact.flatten[0] rescue nil
    return id unless id 
    Supplier.find(id)
    # Supplier.find_by gtin_prefix: prefix
  end

  #
  # implement on every model where search makes sense
  # get's called from controller specific find_resources_queried
  #
  def self.search_by_model_fields lot, query
    default_scope.where "participants.name like '%#{query}%' "
  end

  # def selected? values
  #   return false if values.blank?
  #   values.to_s.split(' ').include? self.id
  # end

    
  #
  # Suppliers - if updated without the participant being 'called'
  #
  def broadcast_update
    if self.participant.deleted_at.nil? 
      broadcast_replace_later_to 'suppliers', partial: self, target: self, locals: { resource: self }
    else 
      broadcast_remove_to 'suppliers', target: self
    end
  end

  def broadcast_destroy
    raise "Suppliers should not be hard-deleteable!"
    # after_destroy_commit { broadcast_remove_to self, partial: self, locals: {resource: self} }
  end
  #
  #

  #
  # used by clone_from method on abstract_resource
  # to exclude has_many associations which should not be cloned
  # when making a copy of some instance of a model
  #
  def excluded_associations_from_cloning
    []
  end

end
