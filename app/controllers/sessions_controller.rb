class SessionsController < ApplicationController

  skip_before_action :authorize, :logout_if_inactive, :check_user_role, :load_current_user, :set_i18n_locale_from_current_user

  def new
  end

  def create
    user = User.find_by(name: params[:name])
    if user.try(:authenticate, params[:password])
      session[:user_id] = user.id
      session[:last_accessed] = Time.current
      return redirect_to(admin_url) unless user.role == 'admin'

      redirect_to admin_reports_path
    else
      redirect_to login_url, alert: "Invalid User/Password Combination"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to store_index_url, notice: t.('.message')
  end
end
