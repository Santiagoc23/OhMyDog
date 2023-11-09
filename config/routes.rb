Rails.application.routes.draw do
  resources :adoptions do
    member do
      patch 'confirm'
    end
  end

  post 'adoption/:id/request', to: 'adoptions#solicitar'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  get 'adoption/:id/request', to: 'adoptions#solicitar', as: :solicitar

end
