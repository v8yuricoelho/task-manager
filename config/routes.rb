# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'tasks#index'

  get 'sessions/new'
  get 'registrations/new'

  resources :tasks, except: %i[edit update]
end
