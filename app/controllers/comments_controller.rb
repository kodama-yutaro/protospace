class CommentsController < ApplicationController

  before_action :set_product

  def create
    @comment = Comment.create(user_id: current_user.id, product_id: params[:product_id], text: comment_params[:text])
    @comments = Comment.all
    @product.reload
  end

  private
  def set_product
    @product = Product.find(params[:product_id])
  end

  def comment_params
    params.require(:comment).permit(:text)
  end
end
