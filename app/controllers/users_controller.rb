class UsersController < ApplicationController
  before_filter :signed_in_user,  only: [:index, :edit, :update, :destroy] 
  before_filter :signed_out_user, only: [:new, :create]
  before_filter :correct_user,    only: [:edit, :update]
  before_filter :admin_user,      only: :destroy

  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @statuses = @user.statuses.paginate(page: params[:page], per_page: 20)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        sign_in @user
        format.html { redirect_to @user, notice: "Welcome to Beacon. It's great to have you on board!" }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update_attributes(user_params)
        flash[:success] = "User was successfully updated."
        format.html { redirect_to @user }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy unless current_user?(@user)

    respond_to do |format|
      flash[:success] = "User was successfully deleted."
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end 

    def signed_out_user
        redirect_to root_url if signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end

    def admin_user
      redirect_to root_url unless current_user.admin?
    end

end
