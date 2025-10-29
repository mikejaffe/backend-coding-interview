class Photographer < ApplicationRecord
  has_many :photos
  scope :active, -> { where(deleted_at: nil) }
  default_scope { active }
  # TODO use rails counter cache instead of this
  scope :with_photo_count, -> { select("photographers.*, (select count(*) from photos where photos.photographer_id = photographers.id) as photo_count") }
end
