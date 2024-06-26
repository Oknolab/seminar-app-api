class UsersController < ApplicationController
  def index
    users = User.all
    render json: { users: users }
  end

  def create
    user = User.new(params_create)
    if user.save
      render json: { user: user }
    else
      render json: { errors: user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def params_create
    params.require(:user).permit(:name, :email, :password)
  end
end
