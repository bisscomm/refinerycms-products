Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :products, :path => Refinery::Products.shop_path do
    root :to => "products#index"

    scope :path => Refinery::Products.products_path do
      resources :products, :path => '', :as => :products, :controller => 'products'
    end

    scope :path => Refinery::Products.products_categories_path do
      resources :categories, :path => '', :as => :categories, :controller => 'categories'
    end
  end

  # Admin routes
  namespace :products, :path => '' do
    namespace :admin, :path => Refinery::Core.backend_route do
      scope :path => Refinery::Products.shop_path do
        root :to => "products#index"

        resources :products, :except => :show do
          collection do
            post :update_positions
            get :uncategorized
          end
        end

        resources :categories

        resources :properties
      end
    end
  end
end