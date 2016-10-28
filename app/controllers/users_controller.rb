class UsersController < ApplicationController

  def status
    render :plain => 'OK'
  end

  def create
    user = User.create(name: user_params[:name], token: SecureRandom.hex(16))
    render :json => user
  end

  private

  def user_params
    params.permit(:name)
  end

end
