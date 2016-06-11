class ProductsController < ApplicationController
  def index
  end

  def new
    @product = Product.new
    @product.product_images.build
  end

  def create
    Product.create(product_params)
    redirect_to products_path
  end

  private
  def product_params
    params.require(:product).permit(
      :title,
      :concept,
      :catch_copy,
      product_images_attributes: [:image, :status]
    ).merge(user_id: current_user.id)
  end
end
