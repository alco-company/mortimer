class ParticipantTeam < ApplicationRecord
  belongs_to :participant
  belongs_to :team
end
