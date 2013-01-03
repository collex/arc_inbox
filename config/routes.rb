ActionController::Routing::Routes.draw do |map|
  map.resources :editorial_board_members

  map.resources :uploaded_files

  map.resources :collections

  map.resources :users

  map.resource :session

  #map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.confirm_submission '/confirm_submission', :controller => 'collections', :action => 'confirm_submission'
  map.resources :users, :member => { :suspend => :put, :unsuspend => :put, :purge => :delete }
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.contributor '/contributor', :controller => 'collections', :action => 'contributor'
  map.editor '/editor', :controller => 'collections', :action => 'editor'
  map.resubmit '/resubmit', :controller => 'collections', :action => 'resubmit'
  map.forgot_password '/forgot_password', :controller => 'users', :action => 'forgot_password'
  map.update_account '/update_account', :controller => 'users', :action => 'update_account'
  map.delete_account '/delete_account', :controller => 'users', :action => 'delete_account'
  map.maintain_editorial_board '/maintain_editorial_board', :controller => 'editorial_board_members', :action => 'index'
  map.added_user_confirmation '/added_user_confirmation', :controller => 'users', :action => 'added_user_confirmation'
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "home", :action => "index"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
