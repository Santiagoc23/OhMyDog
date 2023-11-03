class ApplicationController < ActionController::Base
    
    def after_sign_in_path_for(_resourse)
        dashboard_home_path
    end

    def home
    end
end
