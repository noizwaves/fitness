Rails.application.routes.draw do
  root 'exercises#index'

  resources :exercises
  # get '/exercises', to: 'exercises#index'
  # get '/exercises/:id', to: 'exercises#show'
end
