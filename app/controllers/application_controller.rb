class ApplicationController < ActionController::Base
    
    def after_sign_in_path_for(_resourse)
        dashboard_home_path
    end

    def home
    end

    private 
    def authenticate_admin
        unless current_user.admin?
            redirect_to dashboard_home_path
        end
    end

    def only_user
        if current_user.admin?
            redirect_to dashboard_home_path
        end
    end

end
