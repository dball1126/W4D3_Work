class SessionsController < ApplicationController
    before_action :ensure_logged_in, except: [:create, :new]
    
    def new
        render :new
    end
 
    def create
        user = User.find_by_credentials(
            params[:user][:user_name], 
            params[:user][:password]
        )

        # debugger

        unless user.nil?
            login!(user)
            redirect_to cats_url
        else 
            flash.now[:errors] = ["Invalid user name or password"]
            render :new
        end
    end

    def destroy
        logged_out!

        redirect_to new_session_url
    end

end