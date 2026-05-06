module Api
  module V1
    class FeedItemsController < BaseController
      before_action :set_feed_item, only: [ :show, :mark_as_read ]

      def index
        @feed_items = FeedItem.includes(:feed).recent
        if params[:category].present?
          @feed_items = @feed_items.joins(:feed).where(feeds: { category: params[:category] })
        end

        if params[:unread] == "true"
          @feed_items = @feed_items.unread
        end

        @feed_items = @feed_items.page(params[:page]).per(params[:per] || 20)

        render json: {
          items: @feed_items.as_json(include: { feed: { only: [ :id, :name, :category ] } }, only: [ :id, :title, :url, :guid, :author, :published_at, :content_at, :read ]),
          meta: pagination_meta(@feed_items)
        }
      end

      def show
        @feed_item.mark_as_read!
        render json: @feed_item.as_json(include: { feed: { only: [ :id, :name, :category ] } }, only: [ :id, :title, :url, :guid, :author, :published_at, :content_at, :read ])
      end

      def mark_as_read
        @feed_item.mark_as_read!
        render json: { ok: true }
      end

      def mark_all_as_read
        if params[:category].present?
          FeedItem.joins(:feed).where(feeds: { category: params[:category] }).update_all(read: true)
        else
          FeedItem.update_all(read: true)
        end
        render json: { ok: true }
      end

      private

      def set_feed_item
        @feed_item = FeedItem.find(params[:id])
      end
    end
  end
end
