class SupplierService < ParticipantService

  def get_by field, account, parm    
    Supplier.find_by_prefix( parm["ean14"], account) || create_for_product( account, parm)
  end

  def create_for_product account, parm 
    #
    # search the https://gepir.gs1.org/index.php/search-by-gtin somwhow to find the correct supplier
    #
    resource = Participant.new( name: parm["ean14"][4,4], account: account, participantable: Supplier.new( gtin_prefix: parm["ean14"][4,4] ))
    result = create( resource, Supplier )
    return result.record.participantable if result.created?
    nil
  end

end