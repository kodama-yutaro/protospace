class CommentsController < ApplicationController

  before_action :set_product

  def create
    @comment = current_user.comments.create(comment_params)
    @product.reload
    @comments = @product.comments.includes(:user)
  end

  private
  def set_product
    @product = Product.find(params[:product_id])
  end

  def comment_params
    params.require(:comment).permit(:text).merge(product_id: params[:product_id])
  end
end
