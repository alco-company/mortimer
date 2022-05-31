# frozen_string_literal: true

class RoleComponent < ViewComponent::Base

  def initialize(role:, auth:, index:)
    @role = role
    @auth = auth
    @index = index
    # ISNECUDPF
    @description = [
      "List all records",
      "Show any record",
      "View new record form",
      "View edit record form",
      "Create new record",
      "Update existing record",
      "Delete existing records",
      "Print records",
      "Forward/send/share records"
    ]
  end

end
