class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  skip_before_action :authorize, only: %i[new create]
  before_action :set_user_from_session, only: %i[orders line_items]

  @@line_items_per_page = 5

  # GET /users or /users.json
  def index
    @users = User.order(:name)
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: t('.create_notice') }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_url, notice: t('.update_notice') }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    if @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url, notice: t('.destroy_notice') }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { render :show, status: 403 }
        format.json { head :no_content }
      end
    end
  end

  def orders
  end

  def line_items
    @current_page = page_params.to_i

    @line_items = @user.line_items
                       .limit(@@line_items_per_page)
                       .offset(@@line_items_per_page * (@current_page - 1))
    
    @total_pages = (@user.line_items.count / @@line_items_per_page.to_f).ceil
  end


  rescue_from 'LastUserDeleteError' do |exeption|
    redirect_to users_url, notice: exeption.message
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def set_user_from_session
      @user = User.find(session[:user_id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def page_params
      params.require(:page_id)
    end
end
