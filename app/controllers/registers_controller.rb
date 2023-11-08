class RegistersController < ApplicationController
    before_action :authenticate_user!
    before_action :authenticate_admin, except: [:edit, :update]

    def index
        @users = User.where(role: "user")
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        @user.password = params[:user][:dni] # Utiliza el campo dni como contraseña
        if @user.save
            flash[:notice] = 'Usuario registrado exitosamente.'
            redirect_to registers_path
        else
            flash[:alert] = 'Algun datos ya están vinculados a una cuenta de la aplicación existente.'
            render :new
        end
    end

    def edit
        @user = User.find(params[:id])
        #render :edit, locals: { user: @user }
    end

    def update
        @user = User.find(params[:id])
        if @user.update(user_params_password)
            # La contraseña se actualiza correctamente
            flash[:notice] = 'Contraseña actualizada correctamente.'
            # Iniciar sesión sin requerir la contraseña
            bypass_sign_in(@user)
            # Cambiar firstLogin a false
            current_user.update_attribute(:firstLogin, false)
            # Redirigir al dashboard
            redirect_to dashboard_home_path
        else
            # La contraseña se actualiza correctamente
            flash[:alert] = 'La contraseñas no coincide.'
            # La actualización falla, mostrar errores
            render :edit
        end
    end


    private

    def user_params
        params.require(:user).permit(:name, :surname, :email, :phoneNum, :dni)
    end

    def user_params_password
        params.require(:user).permit(:password, :password_confirmation)
    end

end
