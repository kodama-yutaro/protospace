class LikesController < ApplicationController

  def create
    @like = Like.create(user_id: current_user.id, product_id: params[:product_id])
    @product = Product.find(params[:product_id])
  end

  def destroy
    @like = current_user.likes.find_by(product_id: params[:product_id])
    @like.destroy
    @product = Product.find(params[:product_id])
  end
end
