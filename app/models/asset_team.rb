class AssetTeam < ApplicationRecord
  belongs_to :asset
  belongs_to :team
end
