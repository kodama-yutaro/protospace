class UsersController < ApplicationController
	def show
		@user = User.find(params[:id])
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		result = if current_user.id == @user.id
			@user.update(update_params)
		end

		if result
			sign_in(@user, bypass: true) if current_user.id == @user.id
		end
		redirect_to user_path
	end

	private
	def update_params
		params.require(:user).permit(:nickname, :avatar,  :password, :member, :profile, :work)
	end
end
