require "test_helper"

class TaskTest < ActiveSupport::TestCase

  def setup 
    Current.account = accounts(:one)
  end

  test "as a team I will be assigned to a task" do 
    team = teams(:one)
    team.task = tasks(:one)
    teampart = Participant.create account: accounts(:one), name: 'team', participantable: team
    task = tasks(:one)
    assert_equal team.task, task
  end

  test "as member of a team I inherit the team's task" do
    team = teams(:one)
    user = users(:one)
    event = Event.create account: accounts(:one), name: 'task', eventable: tasks(:one)
    teampart = Participant.create account: accounts(:one), name: 'team', participantable: team
    teampart.team.task = event.task
    userpart = Participant.create account: accounts(:one), name: 'user', participantable: user
    pt = ParticipantTeam.create participant: userpart, team: team, team_role: 'Member'

    say user.teams.first.task.to_json

  end

  # test "" do
  #   user = users(:one)
  #   team = teams(:one)
  #   role1 = roles(:is_god)
  #   role2 = roles(:two)
  #   userpart = Participant.create account: accounts(:one), name: 'user', participantable: user
  #   teampart = Participant.create account: accounts(:one), name: 'team', participantable: team
  #   part = Participant.create account: accounts(:one), name: 'team', participantable: team
  #   assert part.participantable, team

  #   pt = ParticipantTeam.create participant: userpart, team: team, team_role: 'Member'
  # end

end
