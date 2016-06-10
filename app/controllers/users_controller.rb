class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update]

  def show
    hoeghgoehgoe
  end

  def edit
  end

  def update
    current_user.id == @user.id
    @user.update(update_params)
    sign_in(@user, bypass: true)
    redirect_to user_path
  end

  private
  def update_params
    params.require(:user).permit(:nickname, :avatar, :member, :profile, :work)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
