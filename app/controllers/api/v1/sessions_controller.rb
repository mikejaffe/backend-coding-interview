# app/controllers/api/v1/sessions_controller.rb
class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: [ :create ]

  def create
    user = User.find_by(email: session_params[:email])

    if user&.authenticate(session_params[:password])
      user.regenerate_api_token

      render json: {
        token: user.api_token,
        user: {
          id: user.id,
          name: user.name,
          email: user.email
        }
      }, status: :ok
    else
      render json: {
        error: "Invalid email or password"
      }, status: :unauthorized
    end
  end

  def destroy
    current_user.regenerate_api_token if current_user
    head :no_content
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
