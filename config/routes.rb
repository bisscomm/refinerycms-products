Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :products, :path => Refinery::Products.page_path_products_index do
    root :to => "products#index"
    resources :products, :only => [:show]

    get 'categories/:id', :to => 'categories#show', :as => 'category'
  end


  # Admin routes
  namespace :products, :path => '' do
    namespace :admin, :path => Refinery::Core.backend_route do
      scope :path => Refinery::Products.page_path_products_index do
        root :to => "products#index"

        resources :products, :except => :show do
          collection do
            post :update_positions
            get :uncategorized
          end
        end

        resources :categories
      end
    end
  end
end