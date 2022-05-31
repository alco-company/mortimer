require "test_helper"

class RoleTest < ActiveSupport::TestCase

  def setup 
    Current.account = accounts(:one)
  end

  #
  # actions = :index, :show, :new, :edit, :create, :update, :destroy/:delete, :print, :share/:send/:forward
  # role = ISNECUDPF
  #
  test "as a role I can define authorizations for an endpoint" do
    role = roles(:all_products)

    assert role.can :edit, 'product'
    refute role.can :create, 'role'

    role = roles(:es_roles_users)

    assert role.can :show, 'role'
    assert role.can :edit, 'user'

    refute role.can :create, 'role'
    refute role.can :destroy, 'user'

  end

  test "role functionality" do 
    role = Role.new name: "test", role: "ISNECUDPF", context: " "

    # ISNECUDPF
    assert role.can :index, 'role'
    assert role.can :show, 'role'
    assert role.can :new, 'role'
    assert role.can :edit, 'role'
    assert role.can :create, 'role'
    assert role.can :update, 'role'
    assert role.can :destroy, 'role'
    assert role.can :print, 'role'
    assert role.can :forward, 'role'

    # ISNECUDPF
    role.context = "user"
    refute role.can :index, 'role'
    refute role.can :show, 'role'
    refute role.can :new, 'role'
    refute role.can :edit, 'role'
    refute role.can :create, 'role'
    refute role.can :update, 'role'
    refute role.can :destroy, 'role'
    refute role.can :print, 'role'
    refute role.can :forward, 'role'

  end

  test "as a role I can be god" do
    role = roles(:is_god)
    role.context=' '

    assert "ISNECUDPF"==role.role && role.context.blank?

  end

  # test "as an endpoint I can have multiple roles" do
  #   context = Role.arel_table[:context]
  #   assert_equal 2, Role.where(context.matches("%endpoint%")).count 
  # end
  #
  # test "using an endpoint as a user I need to have one of the roles of the endpoint" do
  #
  # end

end
