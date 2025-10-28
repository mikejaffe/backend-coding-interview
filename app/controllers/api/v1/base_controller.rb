class Api::V1::BaseController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  private

  def authenticate_user!
    unless current_user
      user_not_authorized
    end
  end

  def current_user
    @current_user ||= begin
      header = request.headers["Authorization"]
      token = header.split(' ').last if header
      User.find_by(api_token: token) if token
    end
  end

  def user_not_authorized
    render json: { error: "Unauthorized" }, status: :unauthorized
  end
end
