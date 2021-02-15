require 'sidekiq/web'

Rails.application.routes.draw do
  root 'exercises#index'

  mount Sidekiq::Web => '/sidekiq'

  resources :exercises
  # get '/exercises', to: 'exercises#index'
  # get '/exercises/:id', to: 'exercises#show'
end
