Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :products, :path => Refinery::Products.shop_path do
    root to: "categories#index", via: :get
    get "#{Refinery::Products.products_categories_path}/*path", to: 'categories#show', as: :category

    scope :path => Refinery::Products.products_categories_path do
      resources :categories, :path => '', :as => :categories, :controller => 'categories'
    end

    scope :path => Refinery::Products.products_path do
      resources :products, :path => '', :as => :products, :controller => 'products'
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

        get 'categories/*path/edit', to: 'categories#edit', as: 'edit_category'
        get 'categories/*path/children', to: 'categories#children', as: 'children_categories'
        patch 'categories/*path', to: 'categories#update', as: 'update_category'
        delete 'categories/*path', to: 'categories#destroy', as: 'delete_category'

        resources :categories, except: :show do
          post :update_positions, on: :collection
        end

        resources :properties
      end
    end
  end
end