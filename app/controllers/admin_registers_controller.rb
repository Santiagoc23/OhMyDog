class AdminRegistersController < ApplicationController
    before_action :authenticate_user!
    before_action :authenticate_admin

    def index
        @users = User.where(role: "admin")
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        @user.role = 'admin'
        @user.firstLogin = false
        if @user.save
            flash[:notice] = 'Administrador registrado exitosamente.'
            redirect_to admin_registers_path
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

    private

    def user_params
        params.require(:user).permit(:name, :surname, :email, :phoneNum, :dni, :password, :password_confirmation)
    end
end
