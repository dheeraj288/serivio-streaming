class OtpController < ApplicationController
  def new
    @user = User.find_by(email: params[:email])
  end

  def create
    @user = User.find_by(email: params[:email])

    if @user.nil?
      redirect_to login_path, alert: "User not found."
      return
    end

    if params[:otp_code].blank?
      flash.now[:alert] = "Please enter the OTP"
      render :new and return
    end

    if @user.otp_code == params[:otp_code] && @user.otp_sent_at > 10.minutes.ago
      @user.update(otp_verified: true, otp_code: nil)
      session[:user_id] = @user.id
      redirect_to root_path, notice: "OTP verified!"
    else
      flash.now[:alert] = "Invalid or expired OTP"
      render :new
    end
  end

  def resend
    @user = User.find_by(email: params[:email])

    if @user.nil?
      redirect_to login_path, alert: "User not found."
      return
    end

    if @user.otp_sent_at.present? && @user.otp_sent_at > 1.minute.ago
      redirect_to verify_otp_path(email: @user.email), alert: "Please wait before resending OTP."
      return
    end

    @user.generate_otp!
    UserMailer.send_otp(@user).deliver_now

    redirect_to verify_otp_path(email: @user.email), notice: "OTP resent to your email."
  end
end
