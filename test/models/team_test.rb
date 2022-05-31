require "test_helper"

class TeamTest < ActiveSupport::TestCase

  def setup 
    Current.account = accounts(:one)
  end

  test "as a team I can have multiple roles" do

    team = teams(:one)
    role1 = roles(:one)
    role2 = roles(:two)
    part = Participant.create account: accounts(:one), name: 'team', participantable: team
    rl1 = Roleable.create role: role1, roleable: part
    rl2 = Roleable.create role: role2, roleable: part 
    assert_equal team, part.participantable
    assert_equal team.participant, part
    assert_equal rl1.role, role1
    assert_equal rl1.roleable, part
    assert_equal 2, part.roles.count
    assert_equal 'team', team.name
    assert_equal( 2, team.roles.count)

  end

  test "as a member of a team I inherit the roles of the team" do
    user = users(:one)
    team = teams(:one)
    role1 = roles(:is_god)
    role2 = roles(:two)
    userpart = Participant.create account: accounts(:one), name: 'user', participantable: user
    teampart = Participant.create account: accounts(:one), name: 'team', participantable: team

    pt = ParticipantTeam.create participant: userpart, team: team, team_role: 'Member'
    rl1 = Roleable.create role: role1, roleable: teampart 
    rl2 = Roleable.create role: role2, roleable: userpart
    
    assert user.teams.include? team
    assert_equal 2, user.all_roles.count
    assert user.all_roles.include? role2

  end

end
