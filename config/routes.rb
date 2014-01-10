Myflix::Application.routes.draw do


  root to: redirect('/home')

  get '/home', to: 'users#home'
  get '/register', to: 'users#register'
  post '/register', to: 'users#create'
  get '/login', to: 'users#login'
  post '/login', to: 'sessions#create'

  resources :videos, only: [:show, :index] do
    collection do
      post 'search', to: 'videos#search'
    end
  end

  get '/genre/:id', to: 'videos#index_by_category', as: 'genre'

  get 'ui(/:action)', controller: 'ui'

end
