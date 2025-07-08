ActiveAdmin.register Video do
  permit_params :title, :description, :genre, :release_year, :thumbnail, :video_url


  index do
    selectable_column
    id_column
    column :title
    column :description
    column :genre
    column :release_year 
    actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :description
      f.input :genre
      f.input :release_year
      f.input :thumbnail, as: :file
      f.input :video_url, as: :file
    end
    f.actions
  end

  controller do
  def create
    video = Video.new(permitted_params[:video])

    if params[:video][:thumbnail].present?
      uploaded = Cloudinary::Uploader.upload(params[:video][:thumbnail], folder: "thumbnails")
      video.thumbnail = uploaded["secure_url"] if uploaded["secure_url"].present?
    end

    if params[:video][:video_url].present?
      uploaded = Cloudinary::Uploader.upload(params[:video][:video_url], resource_type: :video, folder: "videos")
      video.video_url = uploaded["secure_url"] if uploaded["secure_url"].present?
    end

    if video.save
      redirect_to admin_video_path(video), notice: "Video uploaded successfully"
    else
      flash.now[:alert] = "Upload failed"
      render :new
    end
  end

  def update
    video = Video.find(params[:id])
    video.assign_attributes(permitted_params[:video])

    if params[:video][:thumbnail].present?
      uploaded = Cloudinary::Uploader.upload(params[:video][:thumbnail], folder: "thumbnails")
      video.thumbnail = uploaded["secure_url"] if uploaded["secure_url"].present?
    end

    if params[:video][:video_url].present?
      uploaded = Cloudinary::Uploader.upload(params[:video][:video_url], resource_type: :video, folder: "videos")
      video.video_url = uploaded["secure_url"] if uploaded["secure_url"].present?
    end

    if video.save
      redirect_to admin_video_path(video), notice: "Video updated successfully"
    else
      flash.now[:alert] = "Update failed"
      render :edit
    end
  end
end



  show do
    attributes_table do
      row :title
      row :description
      row :genre
      row :release_year

      row :thumbnail do |video|
        if video.thumbnail.present? && video.thumbnail.start_with?("http")
          image_tag video.thumbnail, width: 200
        end
      end

      row :video_url do |video|
        if video.video_url.present? && video.video_url.start_with?("http")
          video_tag video.video_url, controls: true, width: 300
        end
      end
    end
  end
end