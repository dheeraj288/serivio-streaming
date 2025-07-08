class VideosController < ApplicationController
  before_action :require_login  # ensure user is logged in

  def index
    @videos = Video.order(created_at: :desc)
  end

  def show
    @video = Video.find(params[:id])
  end

  private

  def require_login
    unless session[:user_id]
      redirect_to login_path, alert: "Please login to continue."
    end
  end
end
