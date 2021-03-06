class Admin::AdminController < ApplicationController

  before_filter :require_admin

  def index
    @admin = current_user
    @app_year = Application.current_application_year
  end

  def update_app_year
    new_app_year = params[:app_year].match(/[0-9][0-9][0-9][0-9]/).to_s
    if not new_app_year.empty? and new_app_year == params[:app_year]
      Application.current_application_year = new_app_year.to_i
    else
      flash[:alert] = "Input is not a valid year."
    end
    redirect_to admin_root_path
  end

  private

  def require_admin
    authorize current_user, :is_admin?
  end

end
