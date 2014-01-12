Myflix::Application.routes.draw do


  root to: 'pages#front'

  get '/register', to: 'users#new'
  post '/users', to: 'users#create'
  get '/sign_in', to: 'sessions#new'
  post '/sessions', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'

  resources :videos, only: [:show, :index] do
    collection do
      post 'search', to: 'videos#search'
    end
  end

  get '/genre/:id', to: 'videos#index_by_category', as: 'genre'

  get 'ui(/:action)', controller: 'ui'

end
