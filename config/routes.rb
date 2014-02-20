Myflix::Application.routes.draw do


  root to: 'pages#front'

  get '/sign_in', to: 'sessions#new'
  post '/sessions', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'

  resources :users, only: [:create, :show]
  get '/register', to: 'users#new'

  get '/forgot_password', to: 'password_resets#new'
  post '/confirm_password_reset', to: 'password_resets#create'
  get '/reset_password/:token', to: 'password_resets#show', as: 'reset_password'
  post '/reset_password/:token', to: 'password_resets#update'
  patch '/reset_password/:token', to: 'password_resets#update'


  resources :videos, only: [:show, :index] do
    collection do
      post 'search', to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end
  get '/genre/:id', to: 'videos#index_by_category', as: 'genre'

  resources :queue_items, only: [:create, :destroy]
  get '/my_queue', to: 'queue_items#index'
  post '/my_queue', to: 'queue_items#update_queue'

  resources :followerships, only: [:index, :create, :destroy]

  get 'ui(/:action)', controller: 'ui'

end
