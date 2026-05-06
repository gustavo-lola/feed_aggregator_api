class FeedItem < ApplicationRecord
  belongs_to :feed

  validates :title, presence: true
  validates :url, presence: true
  validates :guid, presence: true, uniqueness: { scope: :feed_id }

  scope :recent, -> { order(created_at: :desc) }
  scope :unread, -> { where(read: false) }

  def mark_as_read!
    update!(read: true)
  end
end
