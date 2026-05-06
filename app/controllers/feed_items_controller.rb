class FeedItemsController < ApplicationController
  def index
    @feed_items = FeedItem.includes(:feed).recent
    if params[:category].present?
      @feed_items = @feed_items.joins(:feed).where(feeds: { category: params[:category] })
    end

    if params[:unread] == "true"
      @feed_items = @feed_items.unread
    end

    @feed_items = @feed_items.page(params[:page]).per(20)
    @categories = Feed.pluck(:category).uniq
  end

  def show
    @feed_item = FeedItem.find(params[:id])
    @feed_item.mark_as_read!
  end

  def mark_as_read
    @feed_item = FeedItem.find(params[:id])
    @feed_item.mark_as_read!

    redirect_back fallback_location: feed_items_path
  end

  def mark_all_as_read
    if params[:category].present?
      FeedItem.joins(:feed).where(feeds: { category: params[:category] }).update_all(read: true)
    else
      FeedItem.update_all(read: true)
    end

    redirect_back fallback_location: feed_items_path, notice: "Todas Notícias Foram Lidas"
  end
end
