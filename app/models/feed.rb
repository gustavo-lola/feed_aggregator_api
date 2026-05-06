class Feed < ApplicationRecord
  has_many :feed_items, dependent: :destroy

  validates :name, presence: true
  validates :url, presence: true, uniqueness: true
  validates :category, presence: true

  before_validation :normalize_fields
  validate :url_must_be_valid

  private

  def normalize_fields
    self.name = name.to_s.strip
    self.url = url.to_s.strip
    self.category = category.to_s.strip

    if self.url.present? && !self.url.match?(%r{\Ahttps?://}i)
      self.url = "http://#{self.url}"
    end
  end

  def url_must_be_valid
    return if url.blank?

    begin
      uri = URI.parse(url)
      unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
        errors.add(:url, 'não é uma URL válida')
      end
    rescue URI::InvalidURIError
      errors.add(:url, 'não é uma URL válida')
    end
  end
end
