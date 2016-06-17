class ProductsController < ApplicationController

  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
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
  end

  def edit
  end

  def update
    if @product.user_id == current_user.id
      @product.update(product_params)
    end
    redirect_to products_path, notice: 'プロトタイプを更新しました。'
  end

  def destroy
    if @product.user_id == current_user.id
      @product.destroy
    end
    redirect_to products_path, notice: 'プロトタイプを削除しました。'
  end

  private
  def product_params
    params.require(:product).permit(
      :title,
      :concept,
      :catch_copy,
      product_images_attributes: [:image, :status, :id]
    )
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
