class UserMailer < ApplicationMailer
  default from: 'your_email@gmail.com'

  def send_otp(user)
    @user = user
    mail(to: @user.email, subject: 'Your OTP Verification Code')
  end
end
