# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?

    # Verificar si firstLogin es true para el usuario que está iniciando sesión
    if current_user.firstLogin
      # Redirigir al formulario para cambiar la contraseña
      redirect_to edit_user_registration_path(id: current_user.id)
    else
      # Redirigir al dashboard u otra página que desees
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
