Rails.application.routes.draw do

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  constraints DomainConstraint.new('kick.party') do
    # Route specifically for the URL shortener
    get '/:id' => "shortener/shortened_urls#show"

    # If nothing matches, send them to the home screen
    root :to => redirect(ENV["BASE_URL"])
  end

  match "*all" => "application#cors_preflight_check", :constraints => { :method => "OPTIONS" }, via: [:get, :post, :put, :patch, :destroy]

  post '/api/events/:id/update', to: 'api/events#update'
  patch '/api/events/:id', to: 'api/events#update'
  post '/api/events/search', to: 'api/events#search'
  delete '/api/events/:id/attendees', to: 'api/attendees#destroy'

  post '/api/attendees/attend', to: 'api/attendees#attend'
  get '/api/events/:id/attendees', to: 'api/attendees#index'
  get '/api/events/:id/attendees/export', to: 'api/attendees#export'
  post '/api/events/attendees/relation', to: 'api/attendees#update_relation'

  get '/events/cal/:id', to: 'api/events#calendar'

  get '/api/reports/:id/daily-signups', to: 'api/reports#daily_signups'

  get '/api/payments/default', to: 'api/payments#default'
  post '/api/payments/default/:id', to: 'api/payments#update_default'

  post '/api/charges/failed/:id', to: 'api/charges#failed'

  patch '/api/users/:id', to: 'api/users#patch'
  get '/api/users/check_slug/:slug', to: 'api/users#check_slug'
  post '/api/users/check_email', to: 'api/users#check_email'
  post '/api/users/update_fb_friends', to: 'api/users#update_fb_friends'

  get '/api/posts/:id', to: 'api/posts#index' # hack to return multiple posts on get :id = :event_id

  get '/images/:id/kickparty-email.png', to: 'api/emails#mark_read'

  post 'api/emails/contact', to:'api/emails#contact_email'

  namespace :api, defaults: { format: :json } do
    devise_for :users, controllers: {sessions: 'api/sessions', registrations: 'api/registrations'}
    get :current_session, controller: 'sessions'
    post :reset_password_request, controller: 'registrations'
    post :reset_password, controller: 'registrations'
    post :facebook_login, controller: 'registrations'
    resources :posts, only: [:create, :index]
    resources :events, only: [:show, :create, :index, :patch, :destroy]
    resources :event_types, only: [:index]
    resources :payments, only: [:create, :index, :show, :destroy]
    resources :orders, only: [:create, :index, :show]
    resources :resource_types, only: [:create, :index]
    resources :resources, only: [:create, :index, :destroy]
    resources :attendees, only: [:create, :index]
    resources :likes, only: [:create, :index, :destroy]
    resources :comments, only: [:create, :index, :destroy]
    resources :charges, only: [:create]
    resources :emails, only: [:create]
    resources :customers, only: [:create]
    resources :users, only: [:show]
    get :error, controller: 'testing'
    get :errors, controller: 'testing'
    resources :relationships, only: [:create, :destroy]
  end

  root 'welcome#index'

end
