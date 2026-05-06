module Api
  module V1
    class BaseController < ActionController::API
      include Devise::Controllers::Helpers

      before_action :set_default_format

      private

      def set_default_format
        request.format = :json
      end

      def pagination_meta(collection)
        return {} unless collection.respond_to?(:current_page)

        {
          page: collection.current_page,
          per_page: collection.limit_value,
          total_pages: collection.total_pages,
          total_count: collection.total_count
        }
      end
    end
  end
end
