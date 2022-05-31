class Roleable < ApplicationRecord
  belongs_to :role
  belongs_to :roleable, polymorphic: true
end
