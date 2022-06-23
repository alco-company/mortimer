module AccountsHelper
  def current_account
    Current.account
  end

  def current_user
    Current.user
  end

  def build_account_name(resource, user = nil)
    user = begin
      (User.unscoped.find user)
    rescue StandardError
      false
    end
    return resource.name unless user or !user.can_impersonate?

    button_to resource.name, account_impersonate_path(resource)
  end
end
