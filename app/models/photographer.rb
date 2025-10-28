class Photographer < ApplicationRecord
  has_many :photos
  scope :active, -> { where(deleted_at: nil) }
  default_scope { active }
end
