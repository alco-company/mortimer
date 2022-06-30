module AccountsHelper
  def current_account
    Current.account
  end

  # def current_user
  #   Current.user
  # end

  def build_account_name(resource, user)
    # user = begin
    #   Current.user
    # rescue StandardError
    #   nil
    # end
    return resource.name if (user.nil? or !user.can_impersonate?)

    button_to resource.name, account_impersonate_path(resource)
  end
end
