class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in?


    def current_user
        @current_user ||= User.find_by(
        session_token: session[:session_token])
    end

    def login!(user)
        @current_user = user
        session[:session_token] = user.reset_session_token!
        
    end

    def logged_out!
        
        current_user.reset_session_token!
        session[:session_token] = nil
        @current_user = nil
        
    end

    def logged_in?
        !!current_user
    end


    def ensure_logged_in
        redirect_to new_session_url unless logged_in?
    end

    def owner_has_cat
    redirect_to new_session_url unless current_user.cats.find_by(id: params[:id])
  end
end
