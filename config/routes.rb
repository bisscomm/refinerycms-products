Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :products do
    resources :products, :path => '', :only => [:index, :show]
  end

  # Admin routes
  namespace :products, :path => '' do
    namespace :admin, :path => Refinery::Core.backend_route do
      resources :products, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end


  # Frontend routes
  namespace :products do
    resources :categories, :only => [:index, :show]
  end

  # Admin routes
  namespace :products, :path => '' do
    namespace :admin, :path => "#{Refinery::Core.backend_route}/products" do
      resources :categories, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end
