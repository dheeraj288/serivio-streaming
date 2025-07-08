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

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "id", "id_value", "name", "otp_code", "otp_sent_at", "otp_verified", "password_digest", "phone", "provider", "uid", "updated_at"]
  end 
end