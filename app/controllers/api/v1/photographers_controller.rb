class Api::V1::PhotographersController < Api::V1::BaseController
  def index
    @photographers = Photographer.select("photographers.*, (select count(*) from photos where photos.photographer_id = photographers.id) as photo_count")
    if params[:name].present?
      @photographers = @photographers.where("name LIKE ?", "%#{params[:name]}%")
    end
    @photographers = @photographers.page(params[:page] || 1).per(params[:per_page] || 10)
  end

  def show
    @photographer = Photographer.select("photographers.*, (select count(*) from photos where photos.photographer_id = photographers.id) as photo_count").where(id: params[:id]).first
    if @photographer.nil?
      render json: { error: "Photographer not found" }, status: :not_found and return
    end
  end

  def create
    @photographer = Photographer.new(photographer_params)
    if @photographer.save
      render "api/v1/photographers/show", status: :created and return
    else
      render json: { error: @photographer.errors.full_messages }, status: :unprocessable_entity and return
    end
  end

  def update
    @photographer = Photographer.where(id: params[:id]).first
    if @photographer.nil?
      render json: { error: "Photographer not found" }, status: :not_found and return
    end
    if @photographer.update(photographer_params)
      render "api/v1/photographers/show", status: :ok and return
    else
      render json: { error: @photographer.errors.full_messages }, status: :unprocessable_entity and return
    end
  end

  def destroy
    @photographer = Photographer.where(id: params[:id]).first
    if @photographer.nil?
      render json: { error: "Photographer not found" }, status: :not_found and return
    end
    @photographer.update(deleted_at: Time.current)
    render json: { message: "Photographer deleted" }, status: :ok and return
  end

  private

  def photographer_params
    params.require(:photographer).permit(:name, :external_avatar_url, :external_url, :external_service, :external_id)
  end
end
