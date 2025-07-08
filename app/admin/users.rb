ActiveAdmin.register User do
  permit_params :name, :email, :phone, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :phone
    column :otp_verified
    column :otp_code # helpful for testing
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :email
      row :phone
      row :otp_verified
      row :otp_code
      row :created_at
      row :updated_at
    end

    # ✅ Only show "Verify OTP" if not yet verified
    if !resource.otp_verified?
      panel "Actions" do
        para do
          link_to "✅ Verify OTP Now", verify_otp_admin_user_path(resource), method: :put, class: "button"
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :phone
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  # ✅ Add custom member action to verify OTP from button
  member_action :verify_otp, method: :put do
    resource.update(otp_verified: true, otp_code: nil)
    redirect_to resource_path, notice: "✅ OTP manually verified from admin."
  end

  controller do
    def create
      @user = User.new(permitted_params[:user])
      @user.otp_code = rand(100000..999999).to_s
      @user.otp_verified = false
      @user.otp_sent_at = Time.current

      if @user.save
        UserMailer.send_otp(@user).deliver_now
        redirect_to admin_user_path(@user), notice: "User created. OTP: #{@user.otp_code}"
      else
        flash.now[:alert] = "Failed to create user."
        render :new
      end
    end
  end
end
