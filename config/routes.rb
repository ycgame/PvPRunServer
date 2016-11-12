Rails.application.routes.draw do

  get '/' => 'users#status'

  mount ActionCable.server => '/cable'

  resources :users, only: [:create]
  get  'users/:id/ranking' => 'users#ranking'
  post 'users/:id/time_attack' => 'users#time_attack'
  post 'users/:id/name' => 'users#update_name'

  post '/ais' => 'ais#req'

end
