Rails.application.routes.draw do
  resources :registers, only: [:index, :new, :create]
  resources :admin_registers, only: [:index, :new, :create]
  get 'dashboard/home'
  root 'homepage#home'

  devise_for :users, skip: [:registrations], controllers: { sessions:'users/sessions'}

  # Rutas para editar usuario y otras funcionalidades proporcionadas por Devise
  resources :users, only: [:edit, :update]

  # Rutas personalizadas para el registro de usuario
  get "/registers", to: "registers#new", as: :new_user_registration
  post "/registers", to: "registers#create", as: :user_registration
  # Rutas para editar y actualizar la contraseña
  get "/registers/edit/:id", to: "registers#edit", as: :edit_user_registration
  patch "/registers/update/:id", to: "registers#update", as: :update_user_registration


end
