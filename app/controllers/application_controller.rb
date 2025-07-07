class ApplicationController < ActionController::Base

   protect_from_forgery with: :exception

  skip_before_action :verify_authenticity_token, if: -> { request.path.start_with?('/auth/') }
  helper_method :current_user, :user_signed_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def user_signed_in?
    current_user.present?
  end

  def require_login
    redirect_to login_path, alert: "You must log in" unless user_signed_in?
  end
end
