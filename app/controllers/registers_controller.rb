class RegistersController < ApplicationController
    before_action :authenticate_user!
    before_action :authenticate_admin, except: [:edit, :update]

    def index
        if params[:dni].present?
            @users = User.where(role: 'user', dni: params[:dni])
        else
            @users = User.where(role: 'user')
        end
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
            if @user.errors[:email].any?
                flash[:alert] = 'El email ya está vinculado a una cuenta existente o no respeta el formato correpondiente.'
            elsif @user.errors[:dni].any?
                flash[:alert] = 'El DNI ya está vinculado a una cuenta existente o no respeta el formato correpondiente.'
            elsif @user.errors[:phoneNum].any?
                flash[:alert] = 'El numero de telefono no respeta el formato correpondiente.'
            else
                flash[:alert] = 'Hubo un problema al registrar el usuario.'
            end
            render :new, status: :unprocessable_entity
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
            flash[:alert] = 'Las contraseñas no coinciden.'
            # La actualización falla, mostrar errores
            render :edit, status: :unprocessable_entity
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
