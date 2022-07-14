class Supplier < AbstractResource
  include Participantable

  has_many :products, dependent: :destroy 
  
  validates :gtin_prefix, presence: true

  #
  # default_scope returns all posts that have not been marked for deletion yet
  #
  def self.default_scope
  #   where("participant" deleted_at: nil)
    Supplier.all.joins(:participant)
  end

  def self.find_by_prefix barcode, account=nil 
    # suppliers = account.nil? ? Supplier.all : Supplier.unscoped.joins(:participant).where('participants.account_id = ?', account.id)
    Current.account = account unless account.nil? 
    suppliers = Supplier.all
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
    return nil if barcode.length < 13
    barcode = "0" + barcode if barcode.length < 14
    id = suppliers.pluck(:id, :gtin_prefix).select{ |k,v| barcode[4,7].match(Regexp.new(v)) ? k : nil  }.compact.flatten[0] rescue nil
    return nil if id.nil? 
    Supplier.find(id)
    # Supplier.find_by gtin_prefix: prefix
  end

  #
  # implement on every model where search makes sense
  # get's called from controller specific find_resources_queried
  #
  def self.search_by_model_fields lot, query
    default_scope.where "participants.name ilike '%#{query}%' "
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
      broadcast_replace_later_to 'suppliers', 
        partial: self, 
        target: self, 
        locals: { resource: self, user: Current.user }
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




# Company name Lindholm Biler A/S
# Domain	lindholmbiler.dk lindholmleasing.dk
# Numeric ID	263840
# VAT ID	DK32768040
# Parent numeric ID	241741

# Language	Danish
# Sales Manager	-
# Marketplaces ALCO Company ApS Marketplace
# CreateUserIdService	false
# Attachments	-

# Contract ID	0010579565
# Customer ID	
# Company contract end date	

# Reference number	
# Terms of payments	
# 30 days
# VAT %	
# 25
# Crefo number

# Address	
# Gl. Århusvej 241B
# City	
# Viborg
# Country	
# Denmark
# Zip code	
# 8800
# Email	
# jn@lindholmbiler.dk
# Contact phone	
# Contact person	
# Technical contact	
# Technical Account Manager	
# Technical contact email

# payment details
# Billing start date	
# 2017-05-10 06:05 (UTC)
# Currency	
# DKK
# Bank name	
# Bank Identifier Code	
# SWIFT code	
# Account number	
# IBAN	
# Account name	
# Branch code	
# Registration number

# demographics
# Industry	
# Employee amount
