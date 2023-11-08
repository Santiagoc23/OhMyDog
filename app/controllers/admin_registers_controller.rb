class AdminRegistersController < ApplicationController
    before_action :authenticate_user!

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
            render :new
        end
    end

    private

    def user_params
        params.require(:user).permit(:name, :surname, :email, :phoneNum, :dni, :password, :password_confirmation)
    end
end
