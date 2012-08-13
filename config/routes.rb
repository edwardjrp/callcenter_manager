Kapiqua25::Application.routes.draw do
  
  

  get 'login', to: "sessions#new", as: :login
  get 'logout', to: "sessions#destroy", as: :logout
  get 'builder', to: "builder#index", as: :builder
  post 'sessions', to: "sessions#create"
  resources :clients do
    collection do 
      post 'import'
    end
  end
  resources :carts do
    collection do
      post 'service_method'
      post 'current_store'
      post 'discount'
      get 'current'
    end
  end
  resources :categories
  resources :addresses do
    collection do
      get 'areas'
      get 'streets'
    end
  end
  resources :phones do 
    collection do 
      get 'clients'
    end
  end
  
  namespace 'admin' do
    resources :categories, :only => :index do
      member do
        post 'set_base'
        post 'change_options'
        post 'change_units'
        post 'change_multi'
        post 'change_hidden'
        post 'change_has_sides'
      end
    end
    resources :addresses
    resources :cities, :only => [:create, :update, :destroy]
    resources :areas, :only => [:create, :update, :destroy]
    resources :streets, :only => [:create, :update, :destroy]
    resources :clients do 
      collection do 
        get 'olo'
      end
    end
    resources :stores, :except=>[:edit]
    resources :store_products, :only =>[:create, :update]
    root :to => 'dashboard#index'
  end
  root to: 'home#index'
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
