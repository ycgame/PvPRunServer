Rails.application.routes.draw do

  mount ActionCable.server => '/cable'

  resources :users, only: [:create]

  post '/ais' => 'ais#req'

end
