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

  def account_logo account, size
    if (account.logo.attached? rescue false)
      account.logo.variant(resize: size)
    else
      size=size.gsub('x','/')
      size=size.gsub('!','')
      "https://picsum.photos/#{size}?grayscale"
    end
  end

  def account_pos_employee_tabs account 
    tabs = []
    account.system_parameters_include("pos/employee").split(" ").each do |tab|
      tabs << { id: "#{tab}_tab", url: "##{tab}_tab", label: t(".#{tab}"), icon: t(".#{tab}_icon"), action: "click->tabs#change" }
    end
    tabs
  end


end
