class ProductsController < ApplicationController

  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.order("created_at DESC").page(params[:page]).per(5).includes(:user, :tags)
  end

  def new
    @product = Product.new
    @product.product_images.build
  end

  def create
    @product = current_user.products.new(product_params)

    if @product.save
      redirect_to products_path, notice: 'プロトタイプを投稿しました。'
    else
      render :new
    end

  end

  def show
    @user = @product.user
    @like = @product.likes.find_by(user_id: current_user.id)
    @comment = Comment.new
    @comments = Comment.where(product_id: @product.id)
  end

  def edit
  end

  def update
    @product.update(product_params) if @product.user_id == current_user.id
    if @product.save
      redirect_to products_path, notice: 'プロトタイプを更新しました。'
    else
      render :edit, notice: 'プロトタイプの更新に失敗しました。'
    end
  end

  def destroy
    @product.destroy if @product.user_id == current_user.id
    redirect_to products_path, notice: 'プロトタイプを削除しました。'
  end

  private
  def product_params
    params.require(:product).permit(
      :title,
      :concept,
      :catch_copy,
      product_images_attributes: [:image, :status, :id]
    ).merge(tag_list: params[:product][:tag])
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
