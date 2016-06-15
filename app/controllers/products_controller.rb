class ProductsController < ApplicationController
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
    @product = Product.find(params[:id])
    @user = @product.user
  end

  private
  def product_params
    params.require(:product).permit(
      :title,
      :concept,
      :catch_copy,
      product_images_attributes: [:image, :status]
    )
  end
end
