class ApplicationController < ActionController::Base
  helper_method :current_user

  before_action :logout_if_inactive
  before_action :authorize, :check_user_role
  before_action :set_i18n_locale_from_params
  before_action :increment_hit_counter

  around_action :benchmark_response_time

  protected

    def current_user
      @current_user ||= User.find(session[:user_id])
    end

    def authorize
      unless User.find_by(id: session[:user_id])
        redirect_to login_url, notice: 'Please Log In'
      end
    end

    def set_i18n_locale_from_params
      if params[:locale]
        if I18n.available_locales.map(&:to_s).include?(params[:locale])
          I18n.locale = params[:locale]
        else
          flash.now[:notice] = "#{params[:locale]} translation not available"
          logger.error flash.now[:notice]
        end
      end
    end

    def increment_hit_counter
      @@hit_counter ||= 0
      @@hit_counter += 1
      @hit_counter = @@hit_counter
    end

    def benchmark_response_time
      start_time = Time.current
      yield
      finish_time = Time.current
      response.headers['x-responded-in'] = finish_time-start_time
    end

    def logout_if_inactive
      return unless session[:user_id]

      if Time.current() - Time.parse(session[:last_accessed]) > 5.minutes
        session[:user_id] = nil
      end

      session[:last_accessed] = Time.current
    end

    def check_user_role
      return unless request.path.split('/')[-2] == 'admin'

      unless current_user.role == 'admin'
        redirect_to(store_index_path, notice: 'You don\'t have privilege to access this section')
      end
    end
end
