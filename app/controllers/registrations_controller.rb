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

  def google_oauth
    user_info = request.env['omniauth.auth']
    user = User.find_or_initialize_by(provider: user_info[:provider], uid: user_info[:uid])

    if user.new_record?
      user.email = user_info[:info][:email]
      user.name = user_info[:info][:name]
      user.phone = user_info[:info][:phone]
      user.password = SecureRandom.hex(10) # dummy password
      user.otp_verified = true
      user.save!
    end

    session[:user_id] = user.id
    redirect_to root_path, notice: "Logged in with Google!"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :phone, :password, :password_confirmation)
  end
end
