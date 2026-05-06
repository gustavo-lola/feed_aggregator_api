class FeedsController < ApplicationController
  before_action :set_feed, only: [ :show, :edit, :update, :destroy, :refresh ]

  def index
    @feeds = Feed.includes(:feed_items).order(:category, :name)
    @categories = @feeds.map(&:category).uniq
    @unread_count = FeedItem.unread.count
  end

  def show
    @feed_items = @feed.feed_items.recent.page(params[:page]).per(20)
  end

  def new
    @feed = Feed.new
  end

  def create
    @feed = Feed.new(feed_params)

    if @feed.save
      begin
        FeedService.new(@feed).fetch
        redirect_to feeds_path, notice: "Feed adicionado com sucesso!"
      rescue => e
        Rails.logger.error("[FeedsController] Failed to fetch feed after create: "+e.message)
        redirect_to feeds_path, notice: "Feed adicionado, mas falha ao buscar notícias agora."
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @feed = Feed.find(params[:id])
  end

  def update
    if @feed.update(feed_params)
      redirect_to @feed, notice: "Feed atualizado com sucesso"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @feed.destroy
    redirect_to feeds_path, notice: "Feed removido com sucesso!"
  end

  def refresh
    begin
      FeedService.new(@feed).fetch
      redirect_to @feed, notice: "Feed atualizado com sucesso"
    rescue => e
      Rails.logger.error("[FeedsController] Failed to fetch feed on refresh: "+e.message)
      redirect_to @feed, alert: "Falha ao atualizar o feed."
    end
  end

  private

  def set_feed
    @feed = Feed.find(params[:id])
  end

  def feed_params
    params.require(:feed).permit(:name, :url, :category)
  end
end
