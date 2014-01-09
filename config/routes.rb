Myflix::Application.routes.draw do


  root to: redirect('/home')

  get '/home', to: 'videos#index'

  resources :videos, only: [:show] do
    collection do
      post 'search', to: 'videos#search'
    end
  end

  get '/genre/:id', to: 'videos#index_by_category', as: 'genre'

  get 'ui(/:action)', controller: 'ui'

end
