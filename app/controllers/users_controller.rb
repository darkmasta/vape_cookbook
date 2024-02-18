class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]


  # POST /users
  def create
    Rails.logger.info "Received params: #{params.inspect}"

    user = User.new(user_params)
    if user.save
      render json: user, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
