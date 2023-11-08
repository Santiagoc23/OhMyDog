Rails.application.routes.draw do
  resources :appointments do
    member do
      get 'confirm_delete'
    end
  end

  patch 'appointments/:id/confirm_user_edit', to: 'appointments#confirm_user_edit', as: 'confirm_user_edit'

  patch 'appointments/:id/confirm_admin_edit', to: 'appointments#confirm_admin_edit', as: 'confirm_admin_edit'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get '/:id/confirm_cancel', to: 'appointments#confirm_cancel', as: :confirm_cancel_appointment
  get '/:id/edit', to: 'appointments#edit', as: :edit__appointment

  get '/requests', to: 'appointments#index_requests', as: :requests
  get '/requests/:id', to: 'appointments#show_request', as: :request

  get '/confirmed', to: 'appointments#index_confirmed', as: :confirmed
  get '/confirmed/:id', to: 'appointments#show_confirmed', as: :confirmed_show
  # Defines the root path route ("/")
  root "application#home"
end
