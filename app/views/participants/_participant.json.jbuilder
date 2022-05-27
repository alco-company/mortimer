json.extract! participant, :id, :account_id, :calendar_id, :participantable_id, :participantable_type, :name, :state, :ancestry, :deleted_at, :created_at, :updated_at
json.url participant_url(participant, format: :json)
