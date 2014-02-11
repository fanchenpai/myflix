Myflix::Application.routes.draw do


  root to: 'pages#front'

  get '/sign_in', to: 'sessions#new'
  post '/sessions', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'

  resources :users, only: [:create, :show]
  get '/register', to: 'users#new'

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

  get 'ui(/:action)', controller: 'ui'

end
