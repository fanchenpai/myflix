Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: redirect('/home')

  get '/home', to: 'videos#index'

  get '/videos/:id', to: 'videos#show', as: 'video'

  get '/genre/:id', to: 'videos#index_by_category', as: 'genre'

end
