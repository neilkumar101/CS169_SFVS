class Admin::UsersController < Admin::AdminController
  before_filter :require_admin

  def index
    @users = User.find(:all, :conditions => ["admin = ?", false])
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "User #{@user.email} has been removed."
    redirect_to admin_users_path
  end
end
