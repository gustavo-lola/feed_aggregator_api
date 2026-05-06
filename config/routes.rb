Rails.application.routes.draw do
  devise_for :users
  root "feed_items#index"

  resources :feeds do
    member do
      post :refresh
    end
  end

  resources :feed_items, only: [:index, :show] do
    member do
      post :mark_as_read
    end

    collection do
      post :mark_all_as_read
    end
  end

  namespace :api do
    namespace :v1 do
      devise_for :users, controllers: { sessions: 'api/v1/users/sessions' }, defaults: { format: :json }

      resources :feeds do
        member do
          post :refresh
        end
      end

      resources :feed_items, only: [:index, :show] do
        member do
          post :mark_as_read
        end

        collection do
          post :mark_all_as_read
        end
      end
    end
  end
    get "up" => "rails/health#show", as: :rails_health_check
end
