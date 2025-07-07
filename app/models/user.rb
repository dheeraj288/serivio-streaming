class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true, uniqueness: true

  def generate_otp!
    self.otp_code = rand(100000..999999).to_s
    self.otp_verified = false
    self.otp_sent_at = Time.current
    save!
  end
end