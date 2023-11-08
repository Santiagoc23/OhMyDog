class ApplicationController < ActionController::Base
    
    def after_sign_in_path_for(_resourse)
        dashboard_home_path
    end

    def home
    end

    private 
    def authenticate_admin
        unless current_user && current_user.admin?
            flash[:alert] = "Acceso denegado - Solo los administradores pueden realizar esta acción."
            redirect_to dashboard_home_path
        end
    end

end
