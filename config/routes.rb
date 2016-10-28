Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  resources :users, only: [:create]
end
