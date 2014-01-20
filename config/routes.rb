Myflix::Application.routes.draw do


  root to: 'pages#front'

  get '/register', to: 'users#new'
  post '/users', to: 'users#create'
  get '/sign_in', to: 'sessions#new'
  post '/sessions', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'
  get '/my_queue', to: 'queue_items#index'

  resources :videos, only: [:show, :index] do
    collection do
      post 'search', to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end

  resources :queue_items, only: [:create, :destroy]

  post '/my_queue', to: 'queue_items#bulk_update'

  get '/genre/:id', to: 'videos#index_by_category', as: 'genre'

  get 'ui(/:action)', controller: 'ui'

end
