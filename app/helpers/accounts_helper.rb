module AccountsHelper

  def current_account
    Current.account 
  end

  def build_account_name resource
    return resource.name unless current_user.can_impersonate?
    button_to resource.name, account_impersonate_path(resource)
  end

end
