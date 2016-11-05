Rails.application.routes.draw do

  get '/' => 'users#status'

  mount ActionCable.server => '/cable'

  resources :users, only: [:create]
  get  'users/:id/ranking' => 'users#ranking'
  post 'users/:id/time_attack' => 'users#time_attack'

  post '/ais' => 'ais#req'

end
