class OrganizationService < ParticipantService

  def get_by field, account, parm    
    Organization.find_by_prefix( parm["ean14"], account) || create_for_product( account, parm)
  end

  def create_for_product account, parm 
    #
    # search the https://gepir.gs1.org/index.php/search-by-gtin somwhow to find the correct supplier
    #
    resource = Participant.new( name: parm["ean14"][4,4], account: account, participantable: Organization.new( gtin_prefix: parm["ean14"][4,4] ))
    result = create( resource )
    return result.record.participantable if result.created?
    nil
  end

end