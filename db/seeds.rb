# Sample feeds for development
feeds = [
  { name: 'BBC World', url: 'https://feeds.bbci.co.uk/news/world/rss.xml', category: 'news' },
  { name: 'CNN Top Stories', url: 'http://rss.cnn.com/rss/edition.rss', category: 'news' },
  { name: 'Hacker News', url: 'https://news.ycombinator.com/rss', category: 'tech' }
]

feeds.each do |f|
  Feed.find_or_create_by!(url: f[:url]) do |feed|
    feed.name = f[:name]
    feed.category = f[:category]
  end
end
