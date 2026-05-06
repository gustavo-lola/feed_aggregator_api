module Api
  module V1
    class FeedsController < BaseController
      before_action :set_feed, only: [:show, :update, :destroy, :refresh]

      def index
        @feeds = Feed.includes(:feed_items).order(:category, :name)
        render json: @feeds.map { |f| feed_json(f) }
      end

      def show
        page = (params[:page] || 1).to_i
        per = (params[:per] || 20).to_i
        feed_items = @feed.feed_items.recent.page(page).per(per)

        render json: {
          feed: feed_json(@feed),
          items: feed_items.as_json(only: [:id, :title, :url, :guid, :author, :published_at, :content_at, :read]),
          meta: pagination_meta(feed_items)
        }
      end

      def create
        @feed = Feed.new(feed_params)
        if @feed.save
          begin
            FeedService.new(@feed).fetch
          rescue => e
            Rails.logger.error("[Api::V1::FeedsController] fetch after create failed: #{e.message}")
          end
          render json: feed_json(@feed), status: :created
        else
          render json: { errors: @feed.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @feed.update(feed_params)
          render json: feed_json(@feed)
        else
          render json: { errors: @feed.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @feed.destroy
        head :no_content
      end

      def refresh
        begin
          FeedService.new(@feed).fetch
          render json: { ok: true }
        rescue => e
          render json: { ok: false, error: e.message }, status: :internal_server_error
        end
      end

      private

      def set_feed
        @feed = Feed.find(params[:id])
      end

      def feed_json(feed)
        feed.as_json(only: [:id, :name, :url, :category]).merge(unread_count: feed.feed_items.where(read: false).count)
      end

      def feed_params
        params.require(:feed).permit(:name, :url, :category)
      end
    end
  end
end
