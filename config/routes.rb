ActionController::Routing::Routes.draw do |map|
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

  map.connect 'omfg',  :controller => 'site', :action => 'omfg'
  map.connect 'hello', :controller => 'site', :action => 'hello'
  map.connect 'about', :controller => 'site', :action => 'about'
  
  map.recent_changes 'recent_changes', :controller => 'site', :action => 'recent_changes'
  map.formatted_recent_changes 'recent_changes.:format', :controller => 'site', :action => 'recent_changes'

  # Normal controllers
  map.resources :events, 
    :collection => {'duplicates' => :get, 'squash_multiple_duplicates' => :post, 'search' => :get}, 
    :member => {'my_events_panel' => :get}
  map.resources :sources, :collection => { :import => :put }
  map.resources :venues, :collection => {'duplicates' => :get, 'squash_multiple_duplicates' => :post}
  map.resource :account do |account|
    # TODO change #create_or_update to a POST
    account.resources :my_events, :controller => "accounts/my_events", :collection => {"create_or_update" => :get}
  end

  # Export action
  map.connect 'export', :controller => 'site', :action => 'export'
  map.connect 'export.:format', :controller => 'site', :action => 'export'
  
  # Stylesheets
  map.connect 'css/:name', :controller => 'site', :action => 'style'
  map.connect 'css/:name.:format', :controller => 'site', :action => 'style'

  # Authentication
  map.resources :users
  map.resource  :session, :collection => ["admin"]
  map.open_id_complete 'session', :controller => "sessions", :action => "create", :requirements => { :method => :get }
  map.login            '/login',  :controller => 'sessions', :action => 'new'
  map.logout           '/logout', :controller => 'sessions', :action => 'destroy'
  map.admin            '/admin',  :controller => 'sessions', :action => 'admin'

  # Site root
  map.root :controller => "site"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
