class ProductsController < ApplicationController
  def index
  end

  def new
    @product = Product.new
    @product.product_images.build
  end

  def create
    current_user.products.create(product_params)

    if current_user.products.create
      redirect_to products_path, notice: 'プロトタイプを投稿しました。'
    else
      render :new
    end

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
