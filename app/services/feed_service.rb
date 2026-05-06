class FeedService
  def initialize(feed)
    @feed = feed
  end

  def fetch
    require 'open-uri'
    raw = URI.open(@feed.url).read
    parsed_feed = Feedjira.parse(raw)
    update_feed(parsed_feed)
    create_or_update_items(parsed_feed)
  rescue StandardError => e
    Rails.logger.error("[FeedService] Fetch failed for feed #{@feed&.id}: #{e.class} - #{e.message}")
    nil
  end

  private

  def update_feed(parsed_feed)
    return unless parsed_feed.respond_to?(:title)
    title = parsed_feed.title
    @feed.update(name: title) if title.present?
  end

  def create_or_update_items(parsed_feed)
    return unless parsed_feed.respond_to?(:entries)

    parsed_feed.entries.each do |entry|
      process_entry(entry)
    rescue StandardError => e
      Rails.logger.warn("[FeedService] Skipping entry in feed #{@feed.id}: #{e.class} - #{e.message}")
    end
  end

  def process_entry(entry)
    guid = extract_guid(entry)
    return if guid.blank?

    item = @feed.feed_items.find_or_initialize_by(guid: guid)
    item.assign_attributes(build_item_attributes(entry))
    item.read = false if item.new_record?
    item.save!
  end

  def build_item_attributes(entry)
    {
      title:        entry_value(entry, :title).presence || "Sem título",
      url:          entry_value(entry, :url) || entry_value(entry, :link),
      published_at: extract_published(entry),
      content:      extract_content(entry),
      author:       entry_value(entry, :author)
    }
  end

  def extract_guid(entry)
    entry_value(entry, :id).presence ||
      entry_value(entry, :entry_id).presence ||
      entry_value(entry, :url)
  end

  def extract_published(entry)
    value = entry_value(entry, :published) || entry_value(entry, :published_at)
    return nil if value.blank?
    value.respond_to?(:iso8601) ? value.iso8601 : value.to_s
  end

  def extract_content(entry)
    value = entry_value(entry, :summary) ||
            entry_value(entry, :content) ||
            entry_value(entry, :description)
    value.to_s.presence
  end


  def entry_value(entry, method)
    entry.respond_to?(method) ? entry.public_send(method).presence : nil
  end
end
