class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      if user.otp_verified?
        session[:user_id] = user.id
        redirect_to root_path, notice: "Logged in!"
      else
        user.generate_otp!
        UserMailer.send_otp(user).deliver_now
        redirect_to verify_otp_path(email: user.email), alert: "OTP sent to your email. Please verify to continue."
      end
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: "Logged out!"
  end
end