Calagator::Application.routes.draw do
  devise_for :users

  scope '(:calendar_type)', :defaults => { :calendar_type => nil } do
    mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

    match 'omfg' => 'site#omfg'
    match 'hello' => 'site#hello'

    match 'about' => 'site#about'

    match 'opensearch.:format' => 'site#opensearch'

    resources :events do
      collection do
        post :squash_many_duplicates
        get :search
        get :duplicates
        get :widget, :action => 'index', :widget => true
      end

      member do
        get :clone
      end
    end

    resources :organizations do
      resources :sources do
        collection do
          post :import
        end
      end
    end

    resources :venues do
      collection do
        post :squash_many_duplicates
        get :map
        get :duplicates
      end
    end

    resources :versions, :only => [:edit]
    resources :changes, :controller => 'paper_trail_manager/changes'
    match 'recent_changes' => redirect("/changes")
    match 'recent_changes.:format' => redirect("/changes.%{format}")

    match 'css/:name' => 'site#style'
    match 'css/:name.:format' => 'site#style'

    match '/' => 'events#index', :as => :root
    match '/index' => 'site#index'
    match '/index.:format' => 'site#index'

    # deprecated routes, remove after 3 months or when too hard to maintain
    get '/topics/:topic_name' => redirect('/events?topic=%{topic_name}') # created: 2013-08-13
    get '/types/:type_name'   => redirect('/events?type=%{type_name}')   # created: 2013-08-13

    match '/:controller(/:action(/:id))'

    root :to => "events#index"
  end
end
