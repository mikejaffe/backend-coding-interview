class Photo < ApplicationRecord
  belongs_to :photographer
  validates :src_urls, presence: true
  scope :active, -> { where(deleted_at: nil) }
  default_scope { active }

  def src_urls_hash
    @src_urls_hash ||= src_urls.is_a?(Hash) ? src_urls : (JSON.parse(src_urls) rescue {})
  end

  def url(size = "original")
    src_urls_hash[size]
  end

  def original_url
    url("original")
  end

  def large_url
    url("large")
  end

  def medium_url
    url("medium")
  end

  def small_url
    url("small")
  end

  def thumbnail_url
    url("tiny")
  end

  def portrait_url
    url("portrait")
  end

  def landscape_url
    url("landscape")
  end
end
