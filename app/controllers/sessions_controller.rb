class SessionsController < ApplicationController
  skip_before_action :authorize, :load_current_user

  def new
  end

  def create
    user = User.find_by(name: params[:name])
    if user.try(:authenticate, params[:password])
      session[:user_id] = user.id
      redirect_to admin_url
    else
      redirect_to login_url, alert: "Invalid User/Password Combination"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to store_index_url, notice: 'Logged Out'
  end
end
