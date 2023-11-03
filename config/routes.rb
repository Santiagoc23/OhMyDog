Rails.application.routes.draw do
  get 'dashboard/home'
  # Defines the root path route ("/")
  root 'homepage#home'
  devise_for :users
end
