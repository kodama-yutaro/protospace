class LikesController < ApplicationController

  before_action :set_product

  def create
    @like = Like.create(user_id: current_user.id, product_id: params[:product_id])
    @product.reload
  end

  def destroy
    @like = current_user.likes.find_by(product_id: params[:product_id])
    @like.destroy
    @product.reload
  end

  private
  def set_product
    @product = Product.find(params[:product_id])
  end

end
