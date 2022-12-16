# frozen_string_literal: true

class RoleComponent < ViewComponent::Base

  def initialize(role:, auth:, index:)
    @role = role
    @auth = auth
    @index = index
    # ISNECUDPF
    @description = "roles.form.auth_#{auth}_description"
  end

end
