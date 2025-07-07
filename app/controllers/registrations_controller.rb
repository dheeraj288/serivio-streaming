class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.generate_otp!

    if @user.save
      UserMailer.send_otp(@user).deliver_now
      redirect_to verify_otp_path(email: @user.email), notice: "OTP sent to your email."
    else
      flash.now[:alert] = "Signup failed"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :phone, :password, :password_confirmation)
  end
end
