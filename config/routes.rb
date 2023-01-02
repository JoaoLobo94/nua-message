Rails.application.routes.draw do

  root :to => 'messages#index'

  resources :messages
  resources :issuing_scripts, only: :create

end
