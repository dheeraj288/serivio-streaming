class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :phone
      t.string :otp_code
      t.boolean :otp_verified
      t.string :provider
      t.string :uid

      t.timestamps
    end
  end
end
