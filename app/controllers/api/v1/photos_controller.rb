class Api::V1::PhotosController < Api::V1::BaseController
  def index
    @photos = Photo.all.includes(:photographer)
    if params[:photographer_id].present?
      @photos = @photos.where(photographer_id: params[:photographer_id])
    end
    @photos = @photos.page(params[:page] || 1).per(params[:per_page] || 10)
  end

  def show
    @photo = Photo.where(id: params[:id]).first
    if @photo.nil?
      render json: { error: "Photo not found" }, status: :not_found and return
    end
  end

  def create
    @photo = Photo.new(photo_params)
    if @photo.save
      render "api/v1/photos/show", status: :created and return
    else
      render json: { error: @photo.errors.full_messages }, status: :unprocessable_entity and return
    end
  end

  def update
    @photo = Photo.where(id: params[:id]).first
    if @photo.nil?
      render json: { error: "Photo not found" }, status: :not_found and return
    end
    if @photo.update(photo_params)
      render "api/v1/photos/show", status: :ok and return
    else
      render json: { error: @photo.errors.full_messages }, status: :unprocessable_entity and return
    end
  end

  def destroy
    @photo = Photo.where(id: params[:id]).first
    if @photo.nil?
      render json: { error: "Photo not found" }, status: :not_found and return
    end
    @photo.update(deleted_at: Time.current)
    render json: { message: "Photo deleted" }, status: :ok and return
  end
  private

  def photo_params
    params.require(:photo).permit(:photographer_id, :external_id, :width, :height, src_urls: {})
  end
end
