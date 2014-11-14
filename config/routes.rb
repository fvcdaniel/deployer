Deployer::Application.routes.draw do
  

devise_for :users,
           :controllers  => {
             :sessions => 'my_devise/sessions'
           }  
  

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  #devise_for :users
  #devise_for :users, :controllers => {:registrations => "registrations"}
  #devise_for :admins, controllers: { sessions: "admins/sessions" }

  get "home/index"
  get "home/secretarias"
  get "home/appservers"
  get "home/apps"
  get "home/request_dep"
  match "home/submeter/:id" => 'home#submeter'
  get "home/dynamic_form"
  get "home/log"

  match "/apps/:id(.:format)" => 'apps#show', :as => :app

  get "/deployer/restart"
  get "/deployer/start"
  get "/deployer/stop"
  get "/deployer/status"
  get "/deployer/deploy"

  get "/apps/:app_id/attachments(.:format)" => 'attachments#index', :as => :app_attachments
  post "/apps/:app_id/attachments(.:format)" => 'attachments#create'
  get "/apps/:app_id/attachments/new(.:format)" => 'attachments#new', :as => :new_app_attachment
  get "/apps/:app_id/attachments/:id/edit(.:format)" => 'attachments#edit', :as => :edit_app_attachment
  get "/apps/:app_id/attachments/:id(.:format)" => 'attachments#show', :as => :app_attachment
  put "/apps/:app_id/attachments/:id(.:format)" => 'attachments#update'
  delete "/apps/:app_id/attachments/:id(.:format)" => 'attachments#destroy'

  #resources :apps do
  #  resources :attachments
  #end

  #resources :apps

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
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
