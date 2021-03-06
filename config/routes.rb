require 'sidekiq/web'
require "admin_constraint"

Kapiqua25::Application.routes.draw do
  


  get "manual", to: 'manual#index'

  mount Sidekiq::Web => 'admin/tasks', :constraints => AdminConstraint.new

  resources :users , :only =>:index
  resources :tax_numbers , :only =>[:create, :update, :destroy] do 
    member do 
      post 'verify'
    end
  end
  get 'login', to: "sessions#new", as: :login
  get 'logout', to: "sessions#destroy", as: :logout
  get 'builder', to: "builder#index", as: :builder
  post 'sessions', to: "sessions#create"
  resources :payments, only: :index
  resources :clients do
    collection do 
      post 'import'
    end

    member do
      post 'set_last_phone'
      post 'set_last_address'
    end
  end
  resources :carts do
    collection do
      post 'service_method'
      post 'current_store'
      post 'discount'
      post 'abandon'
      post 'exonerate'
      post 'release'
      get 'current'
    end
    member do 
      post 'completed'
      put 'coocking_instructions'
      post 'copy_cart_products'
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
    get "manual", to: 'manual#index'
    resources :user_carts, only: [ :create, :destroy ]
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
    resources :reasons, except: [:new, :edit]

    resources :reports, only: [:new, :index, :create, :destroy]

    get "reports/detailed" => "reports#detailed"
    post "reports/detailed" => "reports#generate_detailed"

    get "reports/sumary" => "reports#sumary", as: :report_sumary
    post "reports/sumary" => "reports#generate_sumary"

    get "reports/coupons" => "reports#coupons", as: :report_coupons
    post "reports/coupons" => "reports#generate_coupons"

    get "reports/discounts" => "reports#discounts", as: :report_discounts
    post "reports/discounts" => "reports#generate_discounts"

    get "reports/products_mix" => "reports#products_mix", as: :report_products_mix
    post "reports/products_mix" => "reports#generate_products_mix"


    resources :users
    resources :coupons, except: [:new, :create, :show]
    resources :taxpayer_identifications, only: [:index, :create]
    resources :import_logs
    resources :settings , only: [:index, :create]

    resources :carts do 
      collection do 
        put 'assign'
      end
      member do
        put 'complete_offline'
      end
    end
    resources :addresses, :except => [:new, :show]
    resources :cities, :only => [:index, :create, :update, :destroy]
    resources :areas, :only => [:index, :create, :update, :destroy]
    resources :streets, :only => [:index, :create, :update, :destroy] do
      member do 
        post 'merge'
      end
    end
    resources :clients do 
      collection do 
        get 'olo'
        get 'merge'
        put 'merge_clients'
      end
    end
    resources :stores
    resources :store_products, :only =>[:create, :update] do
      collection do 
        post 'assign_all'
      end
    end
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
